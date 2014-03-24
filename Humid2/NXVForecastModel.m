//
//  NXVForecastModel.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/21/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "NXVForecastModel.h"

@interface NXVForecastModel ()
@property (nonatomic, assign, readwrite) CGFloat      latitude;
@property (nonatomic, assign, readwrite) CGFloat      longitude;
@property (nonatomic, copy, readwrite  ) NSString     *timezone;
@property (nonatomic, assign, readwrite) NSInteger    offset;
@property (nonatomic, copy, readwrite  ) NSDictionary *currentlyDict;
@property (nonatomic, assign, readwrite) NSInteger    currentlyTime;
@property (nonatomic, copy, readwrite  ) NSString     *currentlySummary;
@property (nonatomic, copy, readwrite  ) NSString     *currentlyIcon;
@property (nonatomic, assign, readwrite) CGFloat      currentlyTemperature;
@property (nonatomic, assign, readwrite) CGFloat      currentlyApparentTemperature;
@property (nonatomic, assign, readwrite) CGFloat      currentlyPrecipIntensity;
@property (nonatomic, assign, readwrite) CGFloat      currentlyPrecipProbability;
@property (nonatomic, copy, readwrite  ) NSString     *currentlyPrecipType;
@property (nonatomic, assign, readwrite) CGFloat      currentlyHumidity;
@property (nonatomic, assign, readwrite) CGFloat      currentlyWindSpeed;
@property (nonatomic, assign, readwrite) NSInteger    currentlyWindBearing;
@property (nonatomic, assign, readwrite) NSInteger    currentlyNearestStormDistance;
@property (nonatomic, assign, readwrite) NSInteger    currentlyNearestStormBearing;
@property (nonatomic, assign, readwrite) CGFloat      currentlyDewPoint;
@property (nonatomic, assign, readwrite) CGFloat      currentlyVisibility;
@property (nonatomic, assign, readwrite) CGFloat      currentlyCloudCover;
@property (nonatomic, assign, readwrite) CGFloat      currentlyPressure;
@property (nonatomic, assign, readwrite) CGFloat      currentlyOzone;
@property (nonatomic, copy, readwrite  ) NSDictionary *minutelyDict;
@property (nonatomic, copy, readwrite  ) NSString     *minutelySummary;
@property (nonatomic, copy, readwrite  ) NSArray      *minutelyData;
@property (nonatomic, copy, readwrite  ) NSDictionary *hourlyDict;
@property (nonatomic, copy, readwrite  ) NSString     *hourlySummary;
@property (nonatomic, copy, readwrite  ) NSArray      *hourlyData;
@property (nonatomic, copy, readwrite  ) NSDictionary *dailyDict;
@property (nonatomic, copy, readwrite  ) NSString     *dailySummary;
@property (nonatomic, copy, readwrite  ) NSArray      *dailyData;
@property (nonatomic, copy, readwrite  ) NSString     *unit;
@property (nonatomic, copy, readwrite  ) NSArray      *alerts;
@end

@implementation NXVForecastModel

#pragma mark - Mapping Property

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
	return @{
			   // Model property                  :   JSON value
			   @"latitude"                        :   @"latitude",
			   @"longitude"                       :   @"longitude",
			   @"currentlyDict"                   :   @"currently",
			   @"currentlySummary"                :   @"currently.summary",
			   @"currentlyTemperature"            :   @"currently.temperature",
			   @"currentlyApparentTemperature"    :   @"currently.apparentTemperature",
			   @"currentlyPrecipIntensity"        :   @"currently.precipIntensity",
			   @"currentlyPrecipProbability"      :   @"currently.precipProbability",
			   @"currentlyPrecipType"             :   @"currently.precipType",
			   @"currentlyHumidity"               :   @"currently.humidity",
			   @"currentlyWindSpeed"              :   @"currently.windSpeed",
			   @"currentlyWindBearing"            :   @"currently.windBearing",
			   @"currentlyNearestStormDistance"   :   @"currently.nearestStormDistance",
			   @"currentlyNearestStormBearing"    :   @"currently.nearestStormBearing",
			   @"currentlyDewPoint"               :   @"currently.dewPoint",
			   @"currentlyVisibility"             :   @"currently.visibility",
			   @"currentlyCloudCover"             :   @"currently.cloudCover",
			   @"currentlyPressure"               :   @"currently.pressure",
			   @"currentlyOzone"                  :   @"currently.ozone",
			   @"minutelyDict"                    :   @"minutely",
			   @"minutelySummary"                 :   @"minutely.summary",
			   @"minutelyData"                    :   @"minutely.data",
			   @"hourlyDict"                      :   @"hourly",
			   @"hourlySummary"                   :   @"hourly.summary",
			   @"hourlyData"                      :   @"hourly.data",
			   @"dailyDict"                       :   @"daily",
			   @"dailySummary"                    :   @"daily.summary",
			   @"dailyData"                       :   @"daily.data",
			   @"alerts"                          :   @"alerts",
			   @"unit"                            :   @"flags.units"
	};
}

+ (NSValueTransformer *)assigneeJSONTransformer
{
	return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[self class]];
}

#pragma mark - Debug QuickLook Object

- (id)debugQuickLookObject
{
    CLLocation *debuggingLocation = [[CLLocation alloc] initWithLatitude:self.latitude
                                                               longitude:self.longitude];
    return debuggingLocation;
}


@end
