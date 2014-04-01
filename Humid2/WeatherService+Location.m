//
//  WeatherService+Location.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/31/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "WeatherService+Location.h"

@implementation WeatherService (Location)

- (void)getWeatherForLocation:(CLLocation *)location
                      success:(void (^)(id JSON))success
                      failure:(void (^)(NSError *error, id response))failure
{
    double lat = location.coordinate.latitude;
    double longi = location.coordinate.longitude;
    [self getWeatherForLatitude:lat
                      longitude:longi
                        success:^(id JSON) {
                            success(JSON);
                        }
                        failure:^(NSError *error, id response) {

#ifdef DEBUG
                            DDLogError(@"%s. API call error: %@", __PRETTY_FUNCTION__, error.localizedDescription);
#endif

                            failure(error, response);
                        }];
}

@end
