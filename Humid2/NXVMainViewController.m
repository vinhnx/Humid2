//
//  NXVMainViewController.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/17/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "NXVMainViewController.h"
#import "NXVWeatherDetailsViewController.h"
#import "NXVForecastModel.h"
#import "FCLocationManager.h"

@interface NXVMainViewController () <FCLocationManagerDelegate>
@property (nonatomic, strong) NXVForecastModel  *forecastModel;
@property (nonatomic, copy  ) NSString          *degreeSymbolString;
@property (nonatomic, strong) Reachability      *internetReachability;
@property (nonatomic, assign) BOOL              connectionAvailable;
@property (nonatomic, strong) FCLocationManager *locationManager;
@property (nonatomic, strong) Forecast *forecastManager;
@end

@implementation NXVMainViewController

#pragma mark - View Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"HUMID", nil);
        self.degreeSymbolString = @"\u2103"; // set default degree symbol to ºC
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[SVProgressHUD appearance] setHudFont:[UIFont fontWithName:@"AvenirNext-Medium" size:13]];
    [self startRequestingForecastInfo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupReachabilityManager];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.forecastManager cancelAllForecastRequests];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"] || [segue.identifier isEqualToString:@"didTapViewToShowDetail"]) {
		NXVWeatherDetailsViewController *detailsViewController = [segue destinationViewController];
		detailsViewController.detailString = [NSString stringWithFormat:@"%@\n\n%@\n\n%@",
		                                      self.forecastModel.minutelySummary ?: @"",
		                                      self.forecastModel.hourlySummary ?: @"",
		                                      self.forecastModel.dailySummary] ?: @"";
    }
}

#pragma mark - Private Methods

- (void)startRequestingForecastInfo
{
    if ([CLLocationManager locationServicesEnabled]) {
        [self setupForecastInfo];
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            [self.forecastManager cancelAllForecastRequests];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location Authorization Denied", nil)
                                                                    message:NSLocalizedString(@"You can allow Humid to use your location later in Privacy pane in the Settings app", nil)
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                                          otherButtonTitles:nil];
                [alertView show];
            });
        }
        else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
            [self.forecastManager cancelAllForecastRequests];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location Authorization Restricted", nil)
                                                                    message:NSLocalizedString(@"Humid is not authorized to use location services.", nil)
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                                          otherButtonTitles:nil];
                [alertView show];
            });
        }
    }
    else if (![CLLocationManager locationServicesEnabled]) {
        [self.forecastManager cancelAllForecastRequests];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You are currently not enable location services", nil)
                                                                message:NSLocalizedString(@"Humid only use your location to retrieve weather forecast. You can enable this by enabling Location Services in Privacy pane in the Settings app", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
        });
    }
}

- (IBAction)setupForecastInfo
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Please wait...", nil)
                         maskType:SVProgressHUDMaskTypeGradient];
    [UIView animateWithDuration:1.1
                          delay:.3
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.weatherSummaryLabel.alpha = self.degreeSymbol.alpha = .1;
                     } completion:nil];

    self.locationManager = [FCLocationManager sharedManager];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.forecastManager = [Forecast sharedManager];
    self.forecastManager.APIKey = @""._7._2.c.a._4._8.d._8.b.d._7.d._4.d._1._4._7.b.e.b.f._1.c._8.f.b._9._5._1.f.e._7;
}
#warning lam cache?
- (void)getForecastInfoForLocation:(CLLocation *)location
{
    [SVProgressHUD dismiss];
	@weakify(self);
	[self.forecastManager getForecastForLocation:location
	                                     success: ^(id JSON) {
                                             @strongify(self);
                                             NSError *error = nil;
                                             self.forecastModel = [MTLJSONAdapter modelOfClass:[NXVForecastModel class]
                                                                            fromJSONDictionary:(NSDictionary *)JSON
                                                                                         error:&error];
                                             [self updateViewsWithCallbackResults];
                                             DDLogInfo(@"Reponse: %@", self.forecastModel.currentlySummary);
                                         } failure: ^(NSError *error, id response) {
                                             // handle error
                                             DDLogError(@"ERROR: %@", error.localizedDescription);
                                         }];
}

- (void)updateViewsWithCallbackResults
{
	([self.forecastModel.unit isKindOfClass:[NSString class]] && [self.forecastModel.unit isEqualToString:@"us"])
	? (self.degreeSymbolString = @"\u2109")
	: (self.degreeSymbolString = @"\u2103");
    [UIView animateWithDuration:1
                          delay:.5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.weatherSummaryLabel.text = self.forecastModel ? self.forecastModel.currentlySummary : @"";
                         self.degreeSymbol.text = [NSString stringWithFormat:@"%.f%@",
                                                   ceilf(self.forecastModel.currentlyApparentTemperature),
                                                   self.degreeSymbolString];
                     } completion:^(BOOL finished) {
                         self.weatherSummaryLabel.alpha = self.degreeSymbol.alpha = 1;
                     }];
}

#pragma mark - Reachability handler

- (void)setupReachabilityManager
{
#pragma clang diagnostic push // ignore clang warning
#pragma clang diagnostic ignored "-Warc-retain-cycles"
    // Set the general internet connection availability to YES to avoid issues with lazy reachibility notifier
	self.connectionAvailable = YES;
	// allocate the internet reachability object
	self.internetReachability = [Reachability reachabilityForInternetConnection];
	@weakify(self);
	self.internetReachability.unreachableBlock = ^(Reachability *reachability) {
		dispatch_async(dispatch_get_main_queue(), ^{
		    @strongify(self);
		    // reachability status
		    // Unreachable
		    [self.forecastManager cancelAllForecastRequests];
		    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NETWORK ERROR", nil)
		                                                        message:NSLocalizedString(@"Internet connection seems unreachable!", nil)
		                                                       delegate:nil
		                                              cancelButtonTitle:NSLocalizedString(@"Close", nil)
		                                              otherButtonTitles:nil];
		    [alertView show];
		    DDLogError(@"NETWORK ERROR: %@\n%@",
		               NSLocalizedString(@"Something is not quite right", nil),
		               NSLocalizedString(@"Internet connection seems unreachable!", nil));
		});
	};
	[self.internetReachability startNotifier];
	self.connectionAvailable = [self.internetReachability isReachable];
#pragma clang diagnostic pop
}

#pragma mark - Location Manager Delegate

- (void)didAcquireLocation:(CLLocation *)location
{
    DDLogWarn(@"didAcquireLocation:");
    [self getForecastInfoForLocation:location];
    [self.locationManager findNameForLocation:location];
}

- (void)didFailToAcquireLocationWithErrorMsg:(NSString *)errorMsg
{
    DDLogError(@"didFailToAcquireLocationWithErrorMsg: %@", errorMsg);
    [SVProgressHUD dismiss];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.8
                              delay:.4
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.weatherSummaryLabel.alpha = self.degreeSymbol.alpha = 1;
                         } completion:nil];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Request Timed Out", nil)
                                                            message:errorMsg
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    });
}
#warning if failed request, don't show info button
- (void)didFindLocationName:(NSString *)locationName
{
    DDLogWarn(@"didFindLocationName: %@", locationName);
    self.navigationItem.title = locationName ?: NSLocalizedString(@"HUMID", nil);
}

@end
