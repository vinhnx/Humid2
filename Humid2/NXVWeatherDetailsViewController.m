//
//  NXVWeatherDetailsViewController.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/26/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "NXVWeatherDetailsViewController.h"
#import "NXVForecastModel.h"

@interface NXVWeatherDetailsViewController ()
@property (nonatomic, strong) NXVForecastModel *forecastModel;
@end

@implementation NXVWeatherDetailsViewController

#pragma mark - View Lifecycles

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailsTextView.text = self.detailString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Instance Methods

- (IBAction)dismissDetailsViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
