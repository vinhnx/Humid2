//
//  WeatherService.h
//  Humid2
//
//  Created by Vinh Nguyen on 3/29/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherService : NSObject
@property (nonatomic, strong) NSString *APIKey;

+ (instancetype)sharedInstance;

- (void)getForecastForURL:(NSString *)URL
                 latitude:(double)lat
                longitude:(double)longi
                  success:(void (^)(id JSON))success
                  failure:(void (^)(NSError *error, id repsonse))failure;
@end
