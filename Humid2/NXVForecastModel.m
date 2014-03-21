//
//  NXVForecastModel.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/21/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "NXVForecastModel.h"

@interface NXVForecastModel ()
@property (nonatomic, assign, readwrite) CGFloat latitude;
@property (nonatomic, assign, readwrite) CGFloat longitude;
@property (nonatomic, copy, readwrite) NSString *timezone;
@property (nonatomic, assign, readwrite) NSInteger offset;
@property (nonatomic, copy, readwrite) NSDictionary *currentlyDict;
@property (nonatomic, assign, readwrite) NSInteger currentlyTime;
@property (nonatomic, copy, readwrite) NSString *currentlySummary;
@property (nonatomic, copy, readwrite) NSString *currentlyIcon;
@property (nonatomic, assign, readwrite) CGFloat currentlyTemperature;
@property (nonatomic, assign, readwrite) CGFloat currentlyApparentTemperature;
@property (nonatomic, assign, readwrite) CGFloat currentlyPrecipIntensity;
@property (nonatomic, assign, readwrite) CGFloat currentlyPrecipProbability;
@property (nonatomic, copy, readwrite) NSString *currentlyPrecipType;
@property (nonatomic, assign, readwrite) CGFloat currentlyHumidity;
@property (nonatomic, assign, readwrite) CGFloat currentlyWindSpeed;
@property (nonatomic, assign, readwrite) NSInteger currentlyWindBearing;
@property (nonatomic, assign, readwrite) NSInteger currentlyNearestStormDistance;
@property (nonatomic, assign, readwrite) NSInteger currentlyNearestStormBearing;
@property (nonatomic, assign, readwrite) CGFloat currentlyDewPoint;
@property (nonatomic, assign, readwrite) CGFloat currentlyVisibility;
@property (nonatomic, assign, readwrite) CGFloat currentlyCloudCover;
@property (nonatomic, assign, readwrite) CGFloat currentlyPressure;
@property (nonatomic, assign, readwrite) CGFloat currentlyOzone;
@property (nonatomic, copy, readwrite) NSDictionary *minutelyDict;
@property (nonatomic, copy, readwrite) NSString *minutelySummary;
@property (nonatomic, copy, readwrite) NSArray *minutelyData;
@property (nonatomic, copy, readwrite) NSDictionary *hourlyDict;
@property (nonatomic, copy, readwrite) NSString *hourlySummary;
@property (nonatomic, copy, readwrite) NSArray *hourlyData;
@property (nonatomic, copy, readwrite) NSDictionary *dailyDict;
@property (nonatomic, copy, readwrite) NSString *dailySummary;
@property (nonatomic, copy, readwrite) NSArray *dailyData;
@property (nonatomic, copy, readwrite) NSString *unit;
@property (nonatomic, copy, readwrite) NSArray *alerts;
@end

@implementation NXVForecastModel

#pragma mark - Debug Methods


- (NSString *)description
{
	return [NSString stringWithFormat:@"%@",
	        @{
	            // model property                 :   json value
	            @"latitude"                       :   @(_latitude),
	            @"longitude"                      :   @(_longitude),
	            @"currentlyDict"                  :   _currentlyDict,
	            @"currentlyTemperature"           :   @(_currentlyTemperature),
	            @"currentlyApparentTemperature"   :   @(_currentlyApparentTemperature),
	            @"currentlyPrecipIntensity"       :   @(_currentlyPrecipIntensity),
	            @"currentlyPrecipProbability"     :   @(_currentlyPrecipProbability),
	            @"currentlyPrecipType"            :   _currentlyPrecipType,
	            @"currentlyHumidity"              :   @(_currentlyHumidity),
	            @"currentlyWindSpeed"             :   @(_currentlyWindSpeed),
	            @"currentlyWindBearing"           :   @(_currentlyWindBearing),
	            @"currentlyNearestStormDistance"  :   @(_currentlyNearestStormDistance),
	            @"currentlyNearestStormBearing"   :   @(_currentlyNearestStormBearing),
	            @"currentlyDewPoint"              :   @(_currentlyDewPoint),
	            @"currentlyVisibility"            :   @(_currentlyVisibility),
	            @"currentlyCloudCover"            :   @(_currentlyCloudCover),
	            @"currentlyPressure"              :   @(_currentlyPressure),
	            @"currentlyOzone"                 :   @(_currentlyOzone),
	            @"minutelyDict"                   :   _minutelyDict,
	            @"minutelySummary"                :   _minutelySummary,
	            @"minutelyData"                   :   _minutelyData,
	            @"hourlyDict"                     :   _hourlyDict,
	            @"hourlySummary"                  :   _hourlySummary,
	            @"hourlyData"                     :   _hourlyData,
	            @"dailyDict"                      :   _dailyDict,
	            @"dailySummary"                   :   _dailySummary,
	            @"dailyData"                      :   _dailyData,
	            @"alerts"                         :   _alerts,
	            @"unit"                           :   _unit
			}];
}

- (NSString *)debugDescription
{
	return [NSString stringWithFormat:@"<%@: %p, %@>",
	        [self class],
	        self,
	        @{
	            @"latitude"   : @(_latitude),
	            @"longitude"  : @(_longitude)
			}];
}

@end
