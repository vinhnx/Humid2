//
//  NXVWeatherDetailsViewController.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/26/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "NXVWeatherDetailsViewController.h"

@interface NXVWeatherDetailsViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailsTextView_Constraint_Height;
@end

@implementation NXVWeatherDetailsViewController

#pragma mark - View Lifecycles

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.detailString rangeOfString:@"null"].location != NSNotFound) {
        self.detailString = NSLocalizedString(@"(No weather forecast found, you can try fetching it again.)", nil);
    }
    self.detailsTextView.text = self.detailString;
    self.cityLabel.text = self.cityName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self dismissDetailsViewController:nil];
}

#pragma mark - Instance Methods

- (IBAction)dismissDetailsViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Auto Layout helper

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.detailsTextView_Constraint_Height.constant = 190;
    }
    else {
        self.detailsTextView_Constraint_Height.constant = 240;
    }

    [self.detailsTextView updateConstraintsIfNeeded];
}


@end
