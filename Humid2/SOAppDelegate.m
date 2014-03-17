//
//  NXVAppDelegate.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/17/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "SOAppDelegate.h"
#import "NXVMainViewController.h"
// import any other services singleton instace here
// ...

@implementation SOAppDelegate

// the service are only initizlized once
+ (NSArray *)services
{
    static NSArray *_services = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _services = @[];
    });

    return _services;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NXVMainViewController *mainViewController = [storyBoard instantiateInitialViewController];
    self.window.rootViewController = mainViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
