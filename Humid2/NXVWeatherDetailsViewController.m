//
//  NXVWeatherDetailsViewController.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/26/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "NXVWeatherDetailsViewController.h"

@interface NXVWeatherDetailsViewController ()
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
    if ([self.detailString rangeOfString:@"null"].location != NSNotFound) {
        self.detailString = NSLocalizedString(@"(No weather forecast found, you can try fetching it again.)", nil);
    }
    self.detailsTextView.text = self.detailString;
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

@end
