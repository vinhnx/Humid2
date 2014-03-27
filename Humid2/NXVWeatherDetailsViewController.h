//
//  NXVWeatherDetailsViewController.h
//  Humid2
//
//  Created by Vinh Nguyen on 3/26/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXVWeatherDetailsViewController : UIViewController
@property (nonatomic, copy) NSString   *detailString;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;

- (IBAction)dismissDetailsViewController:(id)sender;
@end
