//
//  WeatherService.h
//  Humid2
//
//  Created by Vinh Nguyen on 3/29/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherService : NSObject

@property (nonatomic, copy) NSString *APIKey; // service API key
@property (nonatomic, copy) NSString *urlStringPattern; // service API call pattern

/**
 *  Fetch JSON info for the given location with success and failure block
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

@end
