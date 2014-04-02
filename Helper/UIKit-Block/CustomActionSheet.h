//
//  CustomActionSheet.h
//  CustomActionSheet
//
//  Created by Vinh Nguyen on 3/5/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionBlock)(NSString *buttonTitle, NSInteger buttonIndex);

@interface CustomActionSheet : NSObject <UIActionSheetDelegate>

/**
 *  Initilize action sheet object with addition information
 *
 *  @param title                  the title of the action sheet
 *  @param delegate               which object should be delegate to
 *  @param cancelButtonTitle      the title of cancel button
 *  @param destructiveButtonTitle the title of destructive (delete) button
 *  @param otherButtonTitles      any other addition titles
 *
 *  @return return the action sheet object!
 */
- (CustomActionSheet *)initWithTitle:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

/**
 *  Showing the action sheet object.
 *
 *  @param view              the view calling action sheet
 *  @param completionHanlder the completion hanlder to perform something
 */
- (void)showInView:(UIView *)view withCompletionHandler:(CompletionBlock)completionHanlder;

@end
