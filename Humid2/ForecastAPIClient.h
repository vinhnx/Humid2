//
//  ForecastAPIClient.h
//  Humid2
//
//  Created by Vinh Nguyen on 3/18/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface ForecastAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
