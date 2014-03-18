//
//  NXVAppDelegate.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/17/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "SOAppDelegate.h"
#import "Forecast.h"
// import any other services singleton instace here
// ...

@implementation SOAppDelegate

// be default, we'll have no services in the delegate
- (NSArray *)services
{
	return nil;
}

#pragma mark - CocoaLumberjack logging configuration

- (void)setupLogging
{
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
	// custom Log Formmater
	[[DDTTYLogger sharedInstance] setLogFormatter:[NXVLogFormatter new]];
	// enable colors
	[[DDTTYLogger sharedInstance] setColorsEnabled:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // initialize log
    [self setupLogging];
    Forecast *forecastManager = [Forecast sharedManager];
    forecastManager.APIKey = @"72ca48d8bd7d4d147bebf1c8fb951fe7";
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
                                            NSLog(@"+++ response: %@", response);
                                        }
                                    }];
	id <UIApplicationDelegate> service;
	// loop through the current services and proxy the delegate call
	for (service in self.services) {
		if ([service respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
			[service application:application didFinishLaunchingWithOptions:launchOptions];
		}
	}
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	id <UIApplicationDelegate> service;
	for (service in self.services) {
		if ([service respondsToSelector:@selector(applicationWillResignActive:)]) {
			[service applicationWillResignActive:application];
		}
	}
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	id <UIApplicationDelegate> service;
	for (service in self.services) {
		if ([service respondsToSelector:@selector(applicationDidEnterBackground:)]) {
			[service applicationDidEnterBackground:application];
		}
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	id <UIApplicationDelegate> service;
	for (service in self.services) {
		if ([service respondsToSelector:@selector(applicationWillEnterForeground:)]) {
			[service applicationWillEnterForeground:application];
		}
	}
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	id <UIApplicationDelegate> service;
	for (service in self.services) {
		if ([service respondsToSelector:@selector(applicationDidBecomeActive:)]) {
			[service applicationDidBecomeActive:application];
		}
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	id <UIApplicationDelegate> service;
	for (service in self.services) {
		if ([service respondsToSelector:@selector(applicationWillTerminate:)]) {
			[service applicationWillTerminate:application];
		}
	}
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	id <UIApplicationDelegate> service;
	BOOL result = NO;
	for (service in self.services) {
		if ([service respondsToSelector:@selector(application:openURL:sourceApplication:annotation:)]) {
			result |= [service application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
		}
	}
	return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	id <UIApplicationDelegate> service;
	BOOL result = NO;
	for (service in self.services) {
		if ([service respondsToSelector:@selector(application:handleOpenURL:)]) {
			result |= [service application:application handleOpenURL:url];
		}
	}
	return result;
}

@end
