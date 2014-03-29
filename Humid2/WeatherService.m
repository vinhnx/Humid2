//
//  WeatherService.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/29/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "WeatherService.h"

@implementation WeatherService

+ (instancetype)sharedInstance
{
    static WeatherService *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [WeatherService new];
    });

    return _sharedInstance;
}

- (void)getForecastForURL:(NSString *)URL
                 latitude:(double)lat
                longitude:(double)longi
                  success:(void (^)(id JSON))success
                  failure:(void (^)(NSError *error, id repsonse))failure
{
    [self checkForAPIKey];
    
}

#pragma mark - Private Methods

- (void)checkForAPIKey
{
    if (!self.APIKey || !self.APIKey.length) {
        [NSException raise:@"Invalid API Key"
                    format:@"API key must be set"];
    }
}


@end
