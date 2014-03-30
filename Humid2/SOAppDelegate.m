//
//  NXVAppDelegate.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/17/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "SOAppDelegate.h"

@implementation SOAppDelegate

// be default, we'll have no services in the delegate
- (NSArray *)services
{
	return nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
