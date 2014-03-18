//
//  ForecastAPIClient.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/18/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "ForecastAPIClient.h"

static NSString *const kForecastAPIClientURLString = @"https://api.forecast.io/forecast/";

@implementation ForecastAPIClient

+ (instancetype)sharedClient
{
    static ForecastAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ForecastAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kForecastAPIClientURLString]];
    });

    return _sharedClient;
}


@end
