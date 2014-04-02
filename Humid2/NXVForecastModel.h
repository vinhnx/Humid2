//
//  NXVForecastModel.h
//  Humid2
//
//  Created by Vinh Nguyen on 3/21/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "MTLModel.h"

@interface NXVForecastModel : MTLModel <MTLJSONSerializing>

//-- General Forecast
/// The requested latitude.
@property (nonatomic, assign, readonly) CGFloat      latitude;
/// The requested longitude.
@property (nonatomic, assign, readonly) CGFloat      longitude;
/// The IANA timezone name for the requested location (e.g. America/New_York). This is the timezone used for text forecast summaries and for determining the exact start time of daily data points. (Developers are advised to rely on local system settings rather than this value if at all possible: users may deliberately set an unusual timezone, and furthermore are likely to know what they actually want better than our timezone database does.)
@property (nonatomic, copy, readonly  ) NSString     *timezone;

/// The current timezone offset in hours from GMT.
@property (nonatomic, assign, readonly) NSInteger    offset;

//-- Currently Forecast
/// A data point containing the current weather conditions at the requested location.
@property (nonatomic, copy, readonly  ) NSDictionary *currentlyDict;
/// The UNIX time (that is, seconds since midnight GMT on 1 Jan 1970) at which this data point occurs.
@property (nonatomic, assign, readonly) NSInteger    currentlyTime;
/// A human-readable text summary of this data point.
@property (nonatomic, copy, readonly  ) NSString     *currentlySummary;
/// A machine-readable text summary of this data point, suitable for selecting an icon for display. If defined, this property will have one of the following values: clear-day, clear-night, rain, snow, sleet, wind, fog, cloudy, partly-cloudy-day, or partly-cloudy-night. (Developers should ensure that a sensible default is defined, as additional values, such as hail, thunderstorm, or tornado, may be defined in the future.)
@property (nonatomic, copy, readonly  ) NSString     *currentlyIcon;
/// A numerical value representing the temperature at the given time in degrees Fahrenheit.
@property (nonatomic, assign, readonly) CGFloat      currentlyTemperature;
/// A numerical value representing the apparent (or “feels like”) temperature at the given time in degrees Fahrenheit.
@property (nonatomic, assign, readonly) CGFloat      currentlyApparentTemperature;
/// A numerical value representing the average expected intensity (in inches of liquid water per hour) of precipitation occurring at the given time conditional on probability (that is, assuming any precipitation occurs at all). A very rough guide is that a value of 0 in./hr. corresponds to no precipitation, 0.002 in./hr. corresponds to very light precipitation, 0.017 in./hr. corresponds to light precipitation, 0.1 in./hr. corresponds to moderate precipitation, and 0.4 in./hr. corresponds to heavy precipitation.
@property (nonatomic, assign, readonly) CGFloat      currentlyPrecipIntensity;
/// A numerical value between 0 and 1 (inclusive) representing the probability of precipitation occuring at the given time.
@property (nonatomic, assign, readonly) CGFloat      currentlyPrecipProbability;
/// A string representing the type of precipitation occurring at the given time. If defined, this property will have one of the following values: rain, snow, sleet (which applies to each of freezing rain, ice pellets, and “wintery mix”), or hail. (If precipIntensity is zero, then this property will not be defined.)
@property (nonatomic, copy, readonly  ) NSString     *currentlyPrecipType;// may be nil
/// A numerical value between 0 and 1 (inclusive) representing the relative humidity.
@property (nonatomic, assign, readonly) CGFloat      currentlyHumidity;
/// A numerical value representing the wind speed in miles per hour.
@property (nonatomic, assign, readonly) CGFloat      currentlyWindSpeed;
/// A numerical value representing the direction that the wind is coming from in degrees, with true north at 0° and progressing clockwise. (If windSpeed is zero, then this value will not be defined.)
@property (nonatomic, assign, readonly) NSInteger    currentlyWindBearing;
/// (only defined on currently data points): A numerical value representing the distance to the nearest storm in miles. (This value is very approximate and should not be used in scenarios requiring accurate results. In particular, a storm distance of zero doesn’t necessarily refer to a storm at the requested location, but rather a storm in the vicinity of that location.)
@property (nonatomic, assign, readonly) NSInteger    currentlyNearestStormDistance;// may be nil
///  (only defined on currently data points): A numerical value representing the direction of the nearest storm in degrees, with true north at 0° and progressing clockwise. (If nearestStormDistance is zero, then this value will not be defined. The caveats that apply to nearestStormDistance also apply to this value.)
@property (nonatomic, assign, readonly) NSInteger    currentlyNearestStormBearing;// may be nil
/// A numerical value representing the dew point at the given time in degrees Fahrenheit.
@property (nonatomic, assign, readonly) CGFloat      currentlyDewPoint;
/// A numerical value representing the average visibility in miles, capped at 10 miles.
@property (nonatomic, assign, readonly) CGFloat      currentlyVisibility;
/// A numerical value between 0 and 1 (inclusive) representing the percentage of sky occluded by clouds. A value of 0 corresponds to clear sky, 0.4 to scattered clouds, 0.75 to broken cloud cover, and 1 to completely overcast skies.
@property (nonatomic, assign, readonly) CGFloat      currentlyCloudCover;
/// A numerical value representing the sea-level air pressure in millibars.
@property (nonatomic, assign, readonly) CGFloat      currentlyPressure;
/// A numerical value representing the columnar density of total atmospheric ozone at the given time in Dobson units.
@property (nonatomic, assign, readonly) CGFloat      currentlyOzone;

//-- Minutely Forecast
/// A data block containing the weather conditions minute-by-minute for the next hour. (This property’s name should be read as an adjective—analogously to “hourly” or “daily” and meaning “reckoned by the minute”—rather than as an adverb meaning “meticulously.” Yes, we know that this is not proper English. No, we will not change it. Complaints to this effect will be deleted with utmost prejudice.)
@property (nonatomic, copy, readonly  ) NSDictionary *minutelyDict;
/// A data block containing the weather conditions day-by-day for the next week.
@property (nonatomic, copy, readonly  ) NSString     *minutelySummary;
/// minutely data
@property (nonatomic, copy, readonly  ) NSArray      *minutelyData;

//-- Hourly Forecast
/// A data block containing the weather conditions hour-by-hour for the next two days.
@property (nonatomic, copy, readonly  ) NSDictionary *hourlyDict;
/// hourly summary
@property (nonatomic, copy, readonly  ) NSString     *hourlySummary;
/// hourly data
@property (nonatomic, copy, readonly  ) NSArray      *hourlyData;

//-- Daily Forecast
/// daily data
@property (nonatomic, copy, readonly  ) NSDictionary *dailyDict;
/// daily summary
@property (nonatomic, copy, readonly  ) NSString     *dailySummary;
/// daily data
@property (nonatomic, copy, readonly  ) NSArray      *dailyData;

//-- Flag, unit
/// The presence of this property indicates which units were used for the data in this request. (For more information, see options, below.)
@property (nonatomic, copy, readonly  ) NSString     *unit;

//-- Alerts
/// An array of alert objects, which, if present, contains any severe weather alerts, issued by a governmental weather authority, pertinent to the requested location.
@property (nonatomic, copy, readonly  ) NSArray      *alerts;

@end
