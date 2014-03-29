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
#import "Wunderground.h"

@interface NXVMainViewController () <FCLocationManagerDelegate>
//@property (nonatomic, strong) Forecast          *forecastManager;
@property (nonatomic, strong) FCLocationManager *locationManager;
@property (nonatomic, strong) NXVForecastModel  *forecastModel;
@property (nonatomic, strong) Reachability      *internetReachability;
@property (nonatomic, strong) Wunderground      *wundergroundService;
@property (nonatomic, copy  ) NSString          *degreeSymbolString;
@property (nonatomic, assign) BOOL              connectionAvailable;
@end

@implementation NXVMainViewController

#pragma mark - View Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"HUMID";
        self.degreeSymbolString = self.degreeSymbolString ?: @"\u2103"; // set default degree symbol to ºC
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupReachabilityManager];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startRequestingForecastInfo];
    [TSMessage setDefaultViewController:self];
    [[SVProgressHUD appearance] setHudFont:[UIFont fontWithName:@"AvenirNext-Medium" size:13]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    [self.forecastManager cancelAllForecastRequests];
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
        detailsViewController.cityName = self.navigationItem.title;
    }
}

#pragma mark - Private Methods

- (void)startRequestingForecastInfo
{
    if ([CLLocationManager locationServicesEnabled]) {
        [self setupForecastInfo];
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            // TODO: call cancel request here...
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
            // TODO: call cancel request here...
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
        // TODO: call cancel request here...
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
//    self.forecastManager = [Forecast sharedManager];
//    self.forecastManager.APIKey = @""._7._2.c.a._4._8.d._8.b.d._7.d._4.d._1._4._7.b.e.b.f._1.c._8.f.b._9._5._1.f.e._7;
    self.wundergroundService = [[Wunderground alloc] init];
    self.wundergroundService.APIKey = @"4633d1a9e6d028b3";
}

- (void)getForecastInfoForLocation:(CLLocation *)location
{
    [SVProgressHUD dismiss];
//	@weakify(self);
    double lat = location.coordinate.latitude;
    double longi = location.coordinate.longitude;
    [self.wundergroundService getWeatherForLatitude:lat
                                          longitude:longi
                                            success:^(id JSON) {
//                                                @strongify(self);
                                                DDLogWarn(@"%@", JSON);
                                            } failure:^(NSError *error, id response) {
                                                //
                                            }];;
//	[self.forecastManager getForecastForLocation:location
//	                                     success:^(id JSON) {
//                                             @strongify(self);
//                                             NSError *error = nil;
//                                             self.forecastModel = [MTLJSONAdapter modelOfClass:[NXVForecastModel class]
//                                                                            fromJSONDictionary:(NSDictionary *)JSON
//                                                                                         error:&error];
//                                             [self updateViewsWithCallbackResults];
//                                             DDLogInfo(@"Reponse: %@", self.forecastModel.currentlySummary);
//                                         } failure:^(NSError *error, id response) {
//                                             // handle error
//                                             DDLogError(@"ERROR: %@", error.localizedDescription);
//                                         }];
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
                                                   ceilf(self.forecastModel.currentlyTemperature),
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
//		    [self.forecastManager cancelAllForecastRequests];
            [TSMessage showNotificationInViewController:self
                                                  title:NSLocalizedString(@"NETWORK ERROR", nil)
                                               subtitle:NSLocalizedString(@"Internet connection seems unreachable!", nil)
                                                   type:TSMessageNotificationTypeWarning
                                               duration:3
                                   canBeDismissedByUser:YES];
		    DDLogError(@"NETWORK ERROR: %@\n%@",
		               NSLocalizedString(@"Something is not quite right", nil),
		               NSLocalizedString(@"Internet connection seems unreachable!", nil));
		});
	};
	[self.internetReachability startNotifier];
	self.connectionAvailable = [self.internetReachability isReachable];
#pragma clang diagnostic pop
    DDLogError(@":::: connection? :%@", self.connectionAvailable ? @"YES" : @"NO");
}

#pragma mark - Location Manager Delegate

- (void)didAcquireLocation:(CLLocation *)location
{
    DDLogWarn(@"didAcquireLocation:");
    if (self.connectionAvailable == YES) {
        [self getForecastInfoForLocation:location];
    }
    [self.locationManager findNameForLocation:location];
}

- (void)didFailToAcquireLocationWithErrorMsg:(NSString *)errorMsg
{
    DDLogError(@"didFailToAcquireLocationWithErrorMsg: %@", errorMsg);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.8
                              delay:.4
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.weatherSummaryLabel.alpha = self.degreeSymbol.alpha = 1;
                         } completion:nil];
        [TSMessage showNotificationInViewController:self
                                              title:NSLocalizedString(@"Request Timed Out", nil)
                                           subtitle:errorMsg
                                               type:TSMessageNotificationTypeError
                                           duration:5
                               canBeDismissedByUser:YES];
    });
}

- (void)didFindLocationName:(NSString *)locationName
{
    // first, we must check if locationManager delegate can reponse to
    // didFindLocationName: optional protocol
    if ([_locationManager.delegate respondsToSelector:@selector(didFindLocationName:)]) {
        DDLogWarn(@"didFindLocationName: %@", locationName);
        self.navigationItem.title = locationName ?: @"HUMID";
    }
}

@end
