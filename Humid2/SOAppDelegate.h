//
//  NXVAppDelegate.h
//  Humid2
//
//  Created by Vinh Nguyen on 3/17/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//


@interface SOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// the list of services that will be integrated into app lifecycle
- (NSArray *)services;

@end
