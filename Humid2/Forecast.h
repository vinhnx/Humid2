//
//  Forecast.h
//  Humid2
//
//  Created by Vinh Nguyen on 3/17/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>


// Updated to match the Forecast.io API as of August 4, 2013

// Cache keys
extern NSString *const kFCCacheKey;
extern NSString *const kFCCacheArchiveKey;
extern NSString *const kFCCacheExpiresKey;
extern NSString *const kFCCacheForecastKey;

// Unit types
extern NSString *const kFCUSUnits;
extern NSString *const kFCSIUnits;
extern NSString *const kFCUKUnits;
extern NSString *const kFCCAUnits;
extern NSString *const kFCAutoUnits;

// Extend types
extern NSString *const kFCExtendHourly;

// Forecast names used for the data block hash keys
extern NSString *const kFCCurrentlyForecast;
extern NSString *const kFCMinutelyForecast;
extern NSString *const kFCHourlyForecast;
extern NSString *const kFCDailyForecast;

// Additional names used for the data block hash keys
extern NSString *const kFCAlerts;
extern NSString *const kFCFlags;
extern NSString *const kFCLatitude;
extern NSString *const kFCLongitude;
extern NSString *const kFCOffset;
extern NSString *const kFCTimezone;

// Names used for the data point hash keys
extern NSString *const kFCCloudCover;
extern NSString *const kFCCloudCoverError;
extern NSString *const kFCDewPoint;
extern NSString *const kFCHumidity;
extern NSString *const kFCHumidityError;
extern NSString *const kFCIcon;
extern NSString *const kFCOzone;
extern NSString *const kFCPrecipAccumulation;
extern NSString *const kFCPrecipIntensity;
extern NSString *const kFCPrecipIntensityMax;
extern NSString *const kFCPrecipIntensityMaxTime;
extern NSString *const kFCPrecipProbability;
extern NSString *const kFCPrecipType;
extern NSString *const kFCPressure;
extern NSString *const kFCPressureError;
extern NSString *const kFCSummary;
extern NSString *const kFCSunriseTime;
extern NSString *const kFCSunsetTime;
extern NSString *const kFCTemperature;
extern NSString *const kFCTemperatureMax;
extern NSString *const kFCTemperatureMaxError;
extern NSString *const kFCTemperatureMaxTime;
extern NSString *const kFCTemperatureMin;
extern NSString *const kFCTemperatureMinError;
extern NSString *const kFCTemperatureMinTime;
extern NSString *const kFCTime;
extern NSString *const kFCVisibility;
extern NSString *const kFCVisibilityError;
extern NSString *const kFCWindBearing;
extern NSString *const kFCWindSpeed;
extern NSString *const kFCWindSpeedError;

// Names used for weather icons
extern NSString *const kFCIconClearDay;
extern NSString *const kFCIconClearNight;
extern NSString *const kFCIconRain;
extern NSString *const kFCIconSnow;
extern NSString *const kFCIconSleet;
extern NSString *const kFCIconWind;
extern NSString *const kFCIconFog;
extern NSString *const kFCIconCloudy;
extern NSString *const kFCIconPartlyCloudyDay;
extern NSString *const kFCIconPartlyCloudyNight;
extern NSString *const kFCIconHail;
extern NSString *const kFCIconThunderstorm;
extern NSString *const kFCIconTornado;
extern NSString *const kFCIconHurricane;

@interface Forecast : NSObject

@end
