//
//  Forecast.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/17/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "Forecast.h"

// Cache keys
NSString *const kFCCacheKey = @"CachedForecasts";
NSString *const kFCCacheArchiveKey = @"ArchivedForecast";
NSString *const kFCCacheExpiresKey = @"ExpiresAt";
NSString *const kFCCacheForecastKey = @"Forecast";
NSString *const kFCCacheJSONPKey = @"JSONP";

/**
 * A common area for changing the names of all constants used in the JSON response
 */

// Unit types
NSString *const kFCUSUnits = @"us";
NSString *const kFCSIUnits = @"si";
NSString *const kFCUKUnits = @"uk";
NSString *const kFCCAUnits = @"ca";
NSString *const kFCAutoUnits = @"auto";

// Extend types
NSString *const kFCExtendHourly = @"hourly";

// Forecast names used for the data block hash keys
NSString *const kFCCurrentlyForecast = @"currently";
NSString *const kFCMinutelyForecast = @"minutely";
NSString *const kFCHourlyForecast = @"hourly";
NSString *const kFCDailyForecast = @"daily";

// Additional names used for the data block hash keys
NSString *const kFCAlerts = @"alerts";
NSString *const kFCFlags = @"flags";
NSString *const kFCLatitude = @"latitude";
NSString *const kFCLongitude = @"longitude";
NSString *const kFCOffset = @"offset";
NSString *const kFCTimezone = @"timezone";

// Names used for the data point hash keys
NSString *const kFCCloudCover = @"cloudCover";
NSString *const kFCCloudCoverError = @"cloudCoverError";
NSString *const kFCDewPoint = @"dewPoint";
NSString *const kFCHumidity = @"humidity";
NSString *const kFCHumidityError = @"humidityError";
NSString *const kFCIcon = @"icon";
NSString *const kFCOzone = @"ozone";
NSString *const kFCPrecipAccumulation = @"precipAccumulation";
NSString *const kFCPrecipIntensity = @"precipIntensity";
NSString *const kFCPrecipIntensityMax = @"precipIntensityMax";
NSString *const kFCPrecipIntensityMaxTime = @"precipIntensityMaxTime";
NSString *const kFCPrecipProbability = @"precipProbability";
NSString *const kFCPrecipType = @"precipType";
NSString *const kFCPressure = @"pressure";
NSString *const kFCPressureError = @"pressureError";
NSString *const kFCSummary = @"summary";
NSString *const kFCSunriseTime = @"sunriseTime";
NSString *const kFCSunsetTime = @"sunsetTime";
NSString *const kFCTemperature = @"temperature";
NSString *const kFCTemperatureMax = @"temperatureMax";
NSString *const kFCTemperatureMaxError = @"temperatureMaxError";
NSString *const kFCTemperatureMaxTime = @"temperatureMaxTime";
NSString *const kFCTemperatureMin = @"temperatureMin";
NSString *const kFCTemperatureMinError = @"temperatureMinError";
NSString *const kFCTemperatureMinTime = @"temperatureMinTime";
NSString *const kFCTime = @"time";
NSString *const kFCVisibility = @"visibility";
NSString *const kFCVisibilityError = @"visibilityError";
NSString *const kFCWindBearing = @"windBearing";
NSString *const kFCWindSpeed = @"windSpeed";
NSString *const kFCWindSpeedError = @"windSpeedError";

// Names used for weather icons
NSString *const kFCIconClearDay = @"clear-day";
NSString *const kFCIconClearNight = @"clear-night";
NSString *const kFCIconRain = @"rain";
NSString *const kFCIconSnow = @"snow";
NSString *const kFCIconSleet = @"sleet";
NSString *const kFCIconWind = @"wind";
NSString *const kFCIconFog = @"fog";
NSString *const kFCIconCloudy = @"cloudy";
NSString *const kFCIconPartlyCloudyDay = @"partly-cloudy-day";
NSString *const kFCIconPartlyCloudyNight = @"partly-cloudy-night";
NSString *const kFCIconHail = @"hail";
NSString *const kFCIconThunderstorm = @"thunderstorm";
NSString *const kFCIconTornado = @"tornado";
NSString *const kFCIconHurricane = @"hurricane";

@interface Forecast () {
    NSUserDefaults *_userDefaults;
    dispatch_queue_t _async_queue;
}

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
        _userDefaults = [NSUserDefaults standardUserDefaults];
        // setup the async queue
        _async_queue = dispatch_queue_create("com.humid2forecast.asyncqueue", NULL);

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

@end
