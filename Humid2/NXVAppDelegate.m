//
//  NXVAppDelegate.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/17/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "NXVAppDelegate.h"
#import "NXVMainViewController.h"
#import "ForecastIO.h"

@interface NXVAppDelegate ()
@property (nonatomic, strong) ForecastIO *forecastIO;
@end

@implementation NXVAppDelegate

// the service are only initizlized once
+ (NSArray *)services
{
    static NSArray *_services = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        _services = @[[Forecast sharedManager]];
        _services = @[[ForecastIO new]];
    });

    return _services;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    [[BlurryModalSegue appearance] setBackingImageBlurRadius:@(20)];
    [[BlurryModalSegue appearance] setBackingImageSaturationDeltaFactor:@(.45)];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NXVMainViewController *mainViewController = [storyBoard instantiateInitialViewController];
    self.window.rootViewController = mainViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
