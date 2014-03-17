//
//  UIAlertView+Block.h
//  UIAlertView+Block
//
//  Created by Vinh Nguyen on 3/5/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Block)
- (void)showWithCompletionHandler:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completionHandler;
@end
