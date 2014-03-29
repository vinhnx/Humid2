//
//  Forecast+CLLocation.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/18/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "Forecast+CLLocation.h"

@implementation Forecast (CLLocation)

- (void)getForecastForLocation:(CLLocation *)location
                       success:(void (^)(id))success
                       failure:(void (^)(NSError *, id))failure
{
    float latitude = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;
    [self getWeatherForLatitude:latitude
                      longitude:longitude
                        success:^(id JSON) {
                            success(JSON);
                        } failure:^(NSError *error, id response) {
                            failure(error, response);
                        }];
}

@end
