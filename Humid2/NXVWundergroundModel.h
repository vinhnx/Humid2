//
//  NXVWundergroundModel.h
//  Humid2
//
//  Created by Vinh Nguyen on 3/31/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXVWundergroundModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *currentlyWeatherSummary;
@property (nonatomic, copy, readonly) NSString *currentlyTemperatureString;
@property (nonatomic, assign, readonly) NSNumber *currentlyTemperatureF;
@property (nonatomic, assign, readonly) NSNumber *currentlyTemperatureC;
@property (nonatomic, strong, readonly) NSString *currentlyForecastURL;

@end
