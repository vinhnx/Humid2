//
//  NXVAppDelegate.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/17/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "NXVAppDelegate.h"
#import "NXVMainViewController.h"
// import any other services singleton instance here
#import "Forecast.h"
#import "Forecast+CLLocation.h"

@implementation NXVAppDelegate
// the service are only initizlized once
+ (NSArray *)services
{
    static NSArray *_services = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _services = @[[Forecast sharedManager]];
    });

    return _services;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NXVMainViewController *mainViewController = [storyBoard instantiateInitialViewController];
    self.window.rootViewController = mainViewController;
    self.window.backgroundColor = [UIColor whiteColor];

    Forecast *forecastManager = [Forecast sharedManager];
    forecastManager.APIKey = @"72ca48d8bd7d4d147bebf1c8fb951fe7";

    /*
    [forecastManager getForecastForLatitude:10.7574
                                  longitude:106.6734
                                    success:^(id JSON) {
                                            if (JSON) {
                                                DDLogWarn(@"%@", JSON);
                                            }
                                        }
                                        failure:^(NSError *error, id response) {
                                            if (error) {
                                                NSLog(@">>> error: %@", error.localizedDescription);
                                            }
                                        }];
    */

    [forecastManager getForecastForLocation:[[CLLocation alloc] initWithLatitude:10.7574 longitude:106.6734]
                                    success:^(id JSON) {
                                        if (JSON) {
//                                            NSLog(@"\n%@", JSON);
                                        }
                                    } failure:^(NSError *error, id response) {
                                        if (error) {
//                                            NSLog(@">>> error: %@", error.localizedDescription);
                                        }
                                    }];


    [self.window makeKeyAndVisible];
    return YES;
}

@end
