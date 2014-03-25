//
//  UITests.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/25/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "UITests.h"
#import <KIF/KIF.h>

@implementation UITests

- (void)beforeAll
{
    [tester waitForViewWithAccessibilityLabel:NSLocalizedString(@"MainView", nil)];
    [tester tapViewWithAccessibilityLabel:NSLocalizedString(@"MainView", nil)];
}

- (void)afterEach
{
    [tester waitForTimeInterval:.5];
}

- (void)tapMainView
{
    [[tester usingTimeout:1] waitForTappableViewWithAccessibilityLabel:NSLocalizedString(@"MainView", nil)];
    [tester tapViewWithAccessibilityLabel:NSLocalizedString(@"MainView", nil)];
}

- (void)tapInfo
{
    [[tester usingTimeout:1] waitForTappableViewWithAccessibilityLabel:NSLocalizedString(@"ShowInfo", nil)];
    [tester tapViewWithAccessibilityLabel:NSLocalizedString(@"ShowInfo", nil)];
}

@end
