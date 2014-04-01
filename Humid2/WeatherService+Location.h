//
//  WeatherService+Location.h
//  Humid2
//
//  Created by Vinh Nguyen on 3/31/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "WeatherService.h"

@interface WeatherService (Location)

/**
 *  Fetch JSON info for the given location
 *  coordinate with success and failure block
 *
 *  @return JSON repsonse
 *
 *  @param latitude  the latitude of the location
 *  @param longitude the longitude of the location
 *  @param success   the block object to be executed when the operation finishes successfully
 *  @param failure   the block object to be executed when the operation finishes unsuccessfully
 */
- (void)getWeatherForLocation:(CLLocation *)location
                      success:(void (^)(id JSON))success
                      failure:(void (^)(NSError *error, id response))failure;

@end
