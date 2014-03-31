//
//  NXVWundergroundModel.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/31/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "NXVWundergroundModel.h"

@interface NXVWundergroundModel ()
@property (nonatomic, copy, readwrite) NSString *currentlyWeatherSummary;
@property (nonatomic, copy, readwrite) NSString *currentlyTemperatureString;
@property (nonatomic, assign, readwrite) NSNumber *currentlyTemperatureF;
@property (nonatomic, assign, readwrite) NSNumber *currentlyTemperatureC;
@property (nonatomic, strong, readwrite) NSString *currentlyForecastURL;
@end

@implementation NXVWundergroundModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             // Model property      :       JSON value
//             @"currentObservation" : @"current_observation",
             @"currentlyWeatherSummary" : @"current_observation.weather",
             @"currentlyTemperatureString" : @"current_observation.temperature_string",
             @"currentlyTemperatureF" : @"current_observation.temp_f",
             @"currentlyTemperatureC" : @"current_observation.temp_c",
             @"currentlyForecastURL" : @"current_observation.forecast_url"
             };
}

+ (NSValueTransformer *)assigneeJSONTransformer
{
	return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[self class]];
}

#pragma mark - Debug QuickLook Object

- (id)debugQuickLookObject
{
    NSURL *url = [NSURL URLWithString:self.currentlyForecastURL];
    return url;
}

@end
