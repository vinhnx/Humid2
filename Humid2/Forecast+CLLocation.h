//
//  Forecast+CLLocation.h
//  Humid2
//
//  Created by Vinh Nguyen on 3/18/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

@import CoreLocation;
#import "Forecast.h"

@interface Forecast (CLLocation)

/**
 *  Request forecast for the given CLLocation
 *
 *  @return the JSON repsone
 *
 *  @param location A CLLocation object
 *  @param success  A block object to be executed when the operation finishes successfully
 *  @param failure  A block object to be executed when the operation finishes unsuccessfully
 */
- (void)getForecastForLocation:(CLLocation *)location
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure;

@end
