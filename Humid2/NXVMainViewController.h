//
//  NXVMainViewController.h
//  Humid2
//
//  Created by Vinh Nguyen on 3/17/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

@interface NXVMainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *weatherSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *degreeSymbol;

- (IBAction)showDetailedWeatherForecastInfo:(id)sender;

@end
