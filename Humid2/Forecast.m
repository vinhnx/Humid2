//
//  Forecast.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/17/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "Forecast.h"

@interface Forecast ()
@end

@implementation Forecast

#pragma mark - Singleton methods

+ (instancetype)sharedManager
{
    static Forecast *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });

    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // init code here
    }
    return self;
}

#pragma mark - Instance methods

- (void)getForecastForLatitude:(double)latitude
                     longitude:(double)longitude
                       success:(void (^)(id))success
                       failure:(void (^)(NSError *, id))failure
{
    // IMPORTANT, we have to check if API key was set
    [self checkAPIKey];

    // generate the URL string based on the passed in params
    NSString *urlString = [self URLStringForLatitude:latitude longitude:longitude];

#ifndef NDEBUG
    NSLog(@"-- Checking forecast for %@", urlString);
#endif

    // call GET request on the API for the URL
    [[ForecastAPIClient sharedClient] GET:urlString
                               parameters:nil
                                  success:^(NSURLSessionDataTask *task, id JSON) {
                                      success(JSON);
                                  }
                                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                                      failure(error, response);
                                  }];
}

- (void)cancelAllForecastRequests
{
    for (id task in [[ForecastAPIClient sharedClient] tasks]) { // loop through all NSURLSession tasks
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
        [NSException raise:@"Forecast"
                    format:@"Forecast.io API key must be set"];
    }
}

- (NSString *)URLStringForLatitude:(double)latitude longitude:(double)longitude
{
    // API call pattern: https://api.forecast.io/forecast/APIKEY/LATITUDE,LONGITUDE
    return [NSString stringWithFormat:@"%@/%.6f,%.6f",
            self.APIKey, latitude, longitude];
}

@end
