//
//  CustomActionSheet.m
//  CustomActionSheet
//
//  Created by Vinh Nguyen on 3/5/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "CustomActionSheet.h"

@interface CustomActionSheet ()
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) void (^completionHandler)(NSString *buttonTitle, NSInteger buttonIndex);
@end
@implementation CustomActionSheet

- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	self = [super init];
	if (self) {
		_actionSheet = [[UIActionSheet alloc] initWithTitle:title
		                                           delegate:self
		                                  cancelButtonTitle:nil
		                             destructiveButtonTitle:destructiveButtonTitle
		                                  otherButtonTitles:nil];

		va_list arguments; // va_list: hold information about variable args
		va_start(arguments, otherButtonTitles); // va_start: initialize variable args list
		NSString *currentButtonTitle = otherButtonTitles;
		while (currentButtonTitle) { // check if there is any addtional button
			[_actionSheet addButtonWithTitle:currentButtonTitle];
			currentButtonTitle = va_arg(arguments, NSString *); // va_arg: retrieve next arg
		}
		va_end(arguments); // va_end: end using variable args list

		[_actionSheet addButtonWithTitle:cancelButtonTitle]; // there is always a cancel button
		[_actionSheet setCancelButtonIndex:_actionSheet.numberOfButtons - 1]; // index of cancel button should be always the total number of all buttons available minus 1
	}

	return self;
}

- (void)showInView:(UIView *)view withCompletionHandler:(void (^)(NSString *buttonTitle, NSInteger buttonIndex))completionHanlder
{
	self.completionHandler = completionHanlder; // assign the completionHanlder property to completionHanlder arg
    dispatch_async(dispatch_get_main_queue(), ^{ // showing UIAlertView on main thread

        [self.actionSheet showInView:view]; // showing the _actionSheet object in the view which is calling it!
    });
}

#pragma mark - UIActionSheetDelegate methods

// IMPORTANT! implement action sheet delegate method actionSheet:ClickedButtonAtIndex: for
// the actionSheet object know which button index is being called
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *buttonTitle = [self.actionSheet buttonTitleAtIndex:buttonIndex];
    if (self.completionHandler) {
        self.completionHandler(buttonTitle, buttonIndex);
    }
}

@end
