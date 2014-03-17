//
//  UIAlertView+Block.m
//  UIAlertView+Block
//
//  Created by Vinh Nguyen on 3/5/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>

@interface NXVAlertWrapper : NSObject
@property (copy) void(^completionHandler)(UIAlertView *alertView, NSInteger buttonIndex);
@end

@implementation NXVAlertWrapper

#pragma mark - UIAlertViewDelegate

// called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.completionHandler) {
        self.completionHandler(alertView, buttonIndex);
    }
}

// called when we cancel a view (eg. the user clicks the Home button). This is not called when the
// user. If not defined in the delegate, we simulate a click in the cancel button
- (void)alertWithCancel:(UIAlertView *)alertView
{
    // just simulate a cancel button click
    if (self.completionHandler) {
        self.completionHandler(alertView, alertView.cancelButtonIndex);
    }
}

@end

static const char kNXVAlertWrapper;
@implementation UIAlertView (Block)

#pragma mark - Class public

- (void)showWithCompletionHandler:(void (^)(UIAlertView *, NSInteger))completionHandler
{
    NXVAlertWrapper *alertWrapper = [NXVAlertWrapper new];
    alertWrapper.completionHandler = completionHandler;
    self.delegate = alertWrapper;

    // set the wrapper as an associated object
    objc_setAssociatedObject(self, &kNXVAlertWrapper, alertWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    // show the alert as normal
    [self show];
}

@end
