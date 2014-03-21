//
//  Forecast.h
//  Humid2
//
//  Created by Vinh Nguyen on 3/17/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "ForecastAPIClient.h"

@interface Forecast : NSObject

@property (nonatomic, copy) NSString *APIKey; // Forecast.io service API key

/**
 *  Initialize and return a new Forecast singleton object
 *
 *  @return A new singleton object
 */
+ (instancetype)sharedManager;

/**
 *  Fetch forecast info for the given location with success and failure block
 *
 *  @return JSON repsonse
 *
 *  @param latitude  the latitude of the location
 *  @param longitude the longitude of the location
 *  @param success   the block object to be executed when the operation finishes successfully
 *  @param failure   the block object to be executed when the operation finishes unsuccessfully
 */
- (void)getForecastForLatitude:(double)latitude
                     longitude:(double)longitude
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure;

/**
 *  Cancel all requests that are currently being executed
 */
- (void)cancelAllForecastRequests;

@end
