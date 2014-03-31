//
//  WeatherService.h
//  Humid2
//
//  Created by Rob Phillips on 4/3/13. Modified by Vinh Nguyen on 3/29/14
//  Copyright (c) 2013 Rob Phillips, Vinh Nguyen. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "WeatherService.h"

// Error domain & enums
NSString *const kHMErrorDomain = @"com.humid2.errors";
typedef enum {
    kHMCachedItemNotFound,
    kHMCacheNotEnabled
} WeatherServiceErrorType;

// Cache keys
NSString *const kHMCacheKey = @"CachedForecasts";
NSString *const kHMCacheArchiveKey = @"ArchivedForecast";
NSString *const kHMCacheExpiresKey = @"ExpiresAt";
NSString *const kHMCacheForecastKey = @"Forecast";
//NSString *const kHMCacheJSONPKey = @"JSONP";

@interface WeatherService () {
    NSUserDefaults *userDefaults;
    dispatch_queue_t async_queue;
}

@property (nonatomic, strong) AFHTTPSessionManager *session;
@end

@implementation WeatherService

#pragma mark - Object Initialize

+ (instancetype)sharedService
{
    static WeatherService *_sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedService = [[WeatherService alloc] init];
    });

    return _sharedService;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *baseURL = [NSURL URLWithString:self.urlStringPattern];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL
                                            sessionConfiguration:config];

        userDefaults = [NSUserDefaults standardUserDefaults];

        // Setup the async queue
        async_queue = dispatch_queue_create("com.humid2.asyncQueue", NULL);

        // Caching defaults
        self.cacheEnabled = YES; // Enable cache by default
        self.cacheExpirationInMinutes = 30; // Set default of 30 minutes
    }
    return self;
}

#pragma mark - Instance Methods

- (void)getWeatherForLatitude:(double)latitude
                    longitude:(double)longitude
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *, id))failure
{
    // IMPORTANT, we have to check if API key was set!
    // else, we raise a NSException flag
    [self checkAPIKey];

    // generate the URL string based on the passed in params
    NSString *urlString = [self URLStringForLatitude:latitude longitude:longitude];

#ifdef DEBUG
    DDLogWarn(@"...checking weather forecast for %@", urlString);
#endif

    // Check if we have a valid cache item that hasn't expired for this URL
    // If caching isn't enabled or a fresh cache item wasn't found, it will execute a server request in the failure block
    NSString *cacheKey = [self cacheKeyForURLString:urlString forLatitude:latitude longitude:longitude];
    [self checkForecastCacheForURLString:cacheKey success:^(id cachedForecast) {
        success(cachedForecast);
    } failure:^(NSError *error) {
        [self.session GET:urlString
               parameters:nil
                  success:^(NSURLSessionDataTask *task, id JSON) {
                      if (self.cacheEnabled) {
                          [self cacheForecast:JSON withURLString:cacheKey];
                      }
                      success(JSON);
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {

#ifdef DEBUG
                      DDLogError(@"%s. API call error: %@", __PRETTY_FUNCTION__, error.localizedDescription);
#endif

                      NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                      failure(error, response);
                  }];
    }];
}

- (void)cancelAllRequests
{
    for (id task in [self.session tasks]) { // loop through all NSURLSession tasks
        if ([task respondsToSelector:@selector(cancel)]) {
            [task cancel];
        }
    }
}

#pragma mark - Private methods

- (void)checkAPIKey
{
    // check for the existence of APIkey
    if (!self.APIKey || !self.APIKey.length) {
		[NSException raise:@"API not found"
		            format:@"Please check if API key was set up properly."];
    }
}

- (NSString *)URLStringForLatitude:(double)latitude longitude:(double)longitude
{
    // Wunderground API call pattern: http://api.wunderground.com/api/APIKEY/conditions/q/LAT,LONGI.json
    // Forecast.io API call pattern: https://api.forecast.io/forecast/APIKEY/LAT,LONGI
    if (self.urlStringPattern.length && self.urlStringPattern) {
        return [NSString stringWithFormat:self.urlStringPattern, self.APIKey, latitude, longitude];
    }
    else {
        [NSException raise:@"Service URL pattern not found"
                    format:@"Please check your URL set up again."];
    }
	return nil;
}

# pragma mark - Cache Instance Methods

// Checks the NSUserDefaults for a cached forecast that is still fresh
- (void)checkForecastCacheForURLString:(NSString *)urlString
                               success:(void (^)(id cachedForecast))success
                               failure:(void (^)(NSError *error))failure
{
    if (self.cacheEnabled) {

        //  Perform this on a background thread
        dispatch_async(async_queue, ^{
            BOOL cachedItemWasFound = NO;
            @try {
                NSDictionary *cachedForecasts = [userDefaults dictionaryForKey:kHMCacheKey];
                if (cachedForecasts) {
                    // Create an NSString object from the coordinates as the dictionary key
                    NSData *archivedCacheItem = [cachedForecasts objectForKey:urlString];
                    // Check if the forecast exists and hasn't expired yet
                    if (archivedCacheItem) {
                        NSDictionary *cacheItem = [self objectForArchive:archivedCacheItem];
                        if (cacheItem) {
                            NSDate *expirationTime = (NSDate *)[cacheItem objectForKey:kHMCacheExpiresKey];
                            NSDate *rightNow = [NSDate date];
                            if ([rightNow compare:expirationTime] == NSOrderedAscending) {
#ifdef DEBUG
                                DDLogWarn(@"Found cached item for %@", urlString);
#endif
                                cachedItemWasFound = YES;
                                // Cache item is still fresh
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    success([cacheItem objectForKey:kHMCacheForecastKey]);
                                });

                            }
                            // As a note, there is no need to remove any stale cache item since it will
                            // be overwritten when the forecast is cached again
                        }
                    }
                }
                if (!cachedItemWasFound) {
                    // If we don't have anything fresh in the cache
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        failure([NSError errorWithDomain:kHMErrorDomain code:kHMCachedItemNotFound userInfo:nil]);
                    });
                }
            }
            @catch (NSException *exception) {
#ifdef DEBUG
                DDLogError(@"Caught an exception while reading from cache (%@)", exception);
#endif
                dispatch_sync(dispatch_get_main_queue(), ^{
                    failure([NSError errorWithDomain:kHMErrorDomain code:kHMCachedItemNotFound userInfo:nil]);
                });
            }
        });

    } else {
        failure([NSError errorWithDomain:kHMErrorDomain code:kHMCacheNotEnabled userInfo:nil]);
    }
}

// Caches a forecast in NSUserDefaults based on the original URL string used to request it
- (void)cacheForecast:(id)forecast withURLString:(NSString *)urlString
{
#ifdef DEBUG
    DDLogWarn(@"Caching item for %@", urlString);
#endif

    // Save to cache on a background thread
    dispatch_async(async_queue, ^{
        NSMutableDictionary *cachedForecasts = [[userDefaults dictionaryForKey:kHMCacheKey] mutableCopy];
        if (!cachedForecasts) cachedForecasts = [[NSMutableDictionary alloc] initWithCapacity:1];

        // Set up the new dictionary we are going to cache
        NSDate *expirationDate = [[NSDate date] dateByAddingTimeInterval:self.cacheExpirationInMinutes * 60]; // X minutes from now
        NSMutableDictionary *newCacheItem = [[NSMutableDictionary alloc] initWithCapacity:2];
        [newCacheItem setObject:expirationDate forKey:kHMCacheExpiresKey];
        [newCacheItem setObject:forecast forKey:kHMCacheForecastKey];

        // Save the new cache item and sync the user defaults
        [cachedForecasts setObject:[self archivedObject:newCacheItem] forKey:urlString];
        [userDefaults setObject:cachedForecasts forKey:kHMCacheKey];
        [userDefaults synchronize];
    });
}

// Removes a cached forecast in case you want to refresh it prematurely
- (void)removeCachedForecastForLatitude:(double)lat longitude:(double)longi time:(NSNumber *)time
{
    NSString *urlString = [self URLStringForLatitude:lat longitude:longi];
    NSString *cacheKey = [self cacheKeyForURLString:urlString forLatitude:lat longitude:longi];

    NSMutableDictionary *cachedForecasts = [[userDefaults dictionaryForKey:kHMCacheKey] mutableCopy];
    if (cachedForecasts) {
#ifdef DEBUG
        DDLogWarn(@"Removing cached item for %@", cacheKey);
#endif
        [cachedForecasts removeObjectForKey:cacheKey];
        [userDefaults setObject:cachedForecasts forKey:kHMCacheKey];
        [userDefaults synchronize];
    }
}

// Flushes all forecasts from the cache
- (void)flushCache
{
#ifdef DEBUG
    DDLogWarn(@"Flushing the cache...");
#endif
    [userDefaults removeObjectForKey:kHMCacheKey];
    [userDefaults synchronize];
}

# pragma mark - Cache Private Methods

// Truncates the latitude and longitude within the URL so that it's more generalized to the user's location
// Otherwise, you end up requesting forecasts from the server even though your lat/lon has only changed by a very small amount
- (NSString *)cacheKeyForURLString:(NSString *)urlString forLatitude:(double)lat longitude:(double)lon
{
    NSString *oldLatLon = [NSString stringWithFormat:@"%f,%f", lat, lon];
    NSString *generalizedLatLon = [NSString stringWithFormat:@"%.2f,%.2f", lat, lon];
    return [urlString stringByReplacingOccurrencesOfString:oldLatLon withString:generalizedLatLon];
}

// Creates an archived object suitable for storing in NSUserDefaults
- (NSData *)archivedObject:(id)object
{
    return object ? [NSKeyedArchiver archivedDataWithRootObject:object] : nil;
}

// Unarchives an object that was stored as NSData
- (id)objectForArchive:(NSData *)archivedObject
{
    return archivedObject ? [NSKeyedUnarchiver unarchiveObjectWithData:archivedObject] : nil;
}

@end
