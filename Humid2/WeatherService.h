//
//  WeatherService.h
//  Humid2
//
//  Created by Rob Phillips on 4/3/13. Modified by Vinh Nguyen on 3/29/14
//  Copyright (c) 2013 Rob Phillips, Vinh Nguyen. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

@interface WeatherService : NSObject

@property (nonatomic, copy) NSString *APIKey; // service's API key
@property (nonatomic, copy) NSString *urlStringPattern; // service's URL call pattern

@property (nonatomic, assign) BOOL cacheEnabled; // default to YES
@property (nonatomic, assign) int cacheExpirationInMinutes; // default to 30 mins

/**
 * Initialize and returns a new WeatherService singleton object
 *  
 * @return A new singleton object
 */
+ (instancetype)sharedService;

/**
 *  Fetch JSON info for the given location's latitude, longitude 
 *  coordinate with success and failure block
 *
 *  @return JSON repsonse
 *
 *  @param latitude  the latitude of the location
 *  @param longitude the longitude of the location
 *  @param success   the block object to be executed when the operation finishes successfully
 *  @param failure   the block object to be executed when the operation finishes unsuccessfully
 */
- (void)getWeatherForLatitude:(double)latitude
                    longitude:(double)longitude
                      success:(void (^)(id JSON))success
                      failure:(void (^)(NSError *error, id response))failure;

/**
 *  Cancel all requests that are currently being executed
 */
- (void)cancelAllRequests;

/**
 * Checks the NSUserDefaults for a cached forecast that is still fresh
 * This will save us round trips and usage for the Forecast.io servers
 * self.cacheEnabled is YES by default, but you can disable it for testing or if you don't want to use it
 *
 * @return The JSON or JSONP response if found and still fresh, otherwise an NSError (that you can ignore)
 *
 * @param forecast The returned JSON or JSONP for the forecast you wish to cache
 * @param urlString The original URL string used to make the request (this assumes your API key doesn't change)
 */
- (void)checkForecastCacheForURLString:(NSString *)urlString
                               success:(void (^)(id cachedForecast))success
                               failure:(void (^)(NSError *error))failure;

/**
 * Caches a forecast, on a background thread, in NSUserDefaults based on the original URL string used to request it
 *
 * @param forecast The returned JSON or JSONP for the forecast you wish to cache
 * @param urlString The original URL string used to make the request (this assumes your API key doesn't change)
 */
- (void)cacheForecast:(id)forecast withURLString:(NSString *)urlString;

/**
 * Removes a cached forecast in case you want to refresh it prematurely
 * Make sure you pass in the exact same params that you used in the original request
 *
 * @param lat The latitude of the location.
 * @param longi The longitude of the location.
 * @param time (Optional) The desired time of the forecast in UNIX GMT format
 * @param exclusions (Optional) An array which specifies which data blocks you would like left off the response
 * @param extend (Optional) Extra commands that are sent to the server
 */
- (void)removeCachedForecastForLatitude:(double)lat
                              longitude:(double)longi
                                   time:(NSNumber *)time;

/**
 * Flushes all forecasts from the cache
 */
- (void)flushCache;

@end
