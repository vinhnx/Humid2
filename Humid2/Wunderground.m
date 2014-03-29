//
//  Wunderground.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/29/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "Wunderground.h"

@interface Wunderground ()
@property (nonatomic, strong) NSURLSession     *session;
@property (nonatomic, strong) NSURLSessionTask *dataTask;
@end

@implementation Wunderground

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
    NSLog(@"[Wunderground] Checking weather forecast for %@", urlString);
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

- (void)cancelAllForecastRequests
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
		            format:@"Wunderground API key must be set"];
    }
}

- (NSString *)URLStringForLatitude:(double)latitude longitude:(double)longitude
{
    // Wunderground API call pattern: http://api.wunderground.com/api/4633d1a9e6d028b3/geolookup/q/10.7794,106.6675.json
	return [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/geolookup/q/%.6f,%.6f.json", self.APIKey, latitude, longitude];
}

@end
