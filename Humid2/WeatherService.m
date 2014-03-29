//
//  WeatherService.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/29/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "WeatherService.h"

@interface WeatherService ()
@property (nonatomic, strong) NSURLSession     *session;
@property (nonatomic, strong) NSURLSessionTask *dataTask;
@end

@implementation WeatherService

#pragma mark - Object Initialize

- (instancetype)init
{
    self = [super init];
    if (self) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

#pragma mark - Instance Methods

- (void)getWeatherForLatitude:(double)latitude
                    longitude:(double)longitude
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *, id))failure
{
    // IMPORTANT, we have to check if API key was set
    [self checkAPIKey];

    // generate the URL string based on the passed in params
    NSString *urlString = [self URLStringForLatitude:latitude longitude:longitude];

#ifdef DEBUG
    DDLogError(@"...checking weather forecast for %@", urlString);
#endif

    // call GET request on the API for the URL
    self.dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:urlString]
                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
									if (!data) {
                                        failure(error, response);
                                        DDLogError(@"%s. API call error: %@", __PRETTY_FUNCTION__, error.localizedDescription);
									}
									else {
										NSError *jsonError = nil;
										id JSON = [NSJSONSerialization JSONObjectWithData:data
										                                          options:kNilOptions
										                                            error:&jsonError];
                                        success(JSON);
									}
                                }];
    [self.dataTask resume];
}

- (void)cancelAllRequests
{
    if ([self.dataTask respondsToSelector:@selector(cancel)]) {
        [self.dataTask cancel];
    }
}

#pragma mark - Private methods

- (void)checkAPIKey
{
    // check for the existence of APIkey
    if (!self.APIKey || !self.APIKey.length) {
		[NSException raise:@"API not found"
		            format:@"API key must be set"];
    }
}

- (NSString *)URLStringForLatitude:(double)latitude longitude:(double)longitude
{
    // Wunderground API call pattern: http://api.wunderground.com/api/APIKEY/geolookup/q/LAT,LONGI.json
    // Forecast.io API call pattern: https://api.forecast.io/forecast/APIKEY/LAT,LONGI
    NSString *url = @"";
    if (self.urlStringPattern.length && self.urlStringPattern) {
        url = [NSString stringWithFormat:self.urlStringPattern, self.APIKey, latitude, longitude];
    }
	return url;
}

@end
