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

// testing location lat and long coordinate keys
static double NXVLatitude = 10.7574;
static double NXVLongitude = 106.6734;

@interface NXVMainViewController ()
@property (nonatomic, strong) NXVForecastModel       *forecastModel;
@property (nonatomic, copy  ) NSString               *degreeSymbolString;
@property (nonatomic, strong) Reachability           *internetReachability;
@property (nonatomic, assign) BOOL                   connectionAvailable;
@end

@implementation NXVMainViewController

#pragma mark - View Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Humid", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupForecastInfo];
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
    [[Forecast sharedManager] cancelAllForecastRequests];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NXVWeatherDetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.detailString = [NSString stringWithFormat:@"%@\n\n%@\n\n%@",
                                           self.forecastModel.minutelySummary ?: @"",
                                           self.forecastModel.hourlySummary,
                                           self.forecastModel.dailySummary];
    }
}

#pragma mark - Private Methods

- (void)setupForecastInfo
{
    Forecast *forecastManager = [Forecast sharedManager];
    forecastManager.APIKey = @""._7._2.c.a._4._8.d._8.b.d._7.d._4.d._1._4._7.b.e.b.f._1.c._8.f.b._9._5._1.f.e._7;

    CLLocation *location = [[CLLocation alloc] initWithLatitude:NXVLatitude
                                                      longitude:NXVLongitude];
    @weakify(self);
    [forecastManager getForecastForLocation:location
                                    success:^(id JSON) {
                                        @strongify(self);
										if (!self.forecastModel) {
											NSError *error = nil;
											self.forecastModel = [MTLJSONAdapter modelOfClass:[NXVForecastModel class]
											                               fromJSONDictionary:(NSDictionary *)JSON
											                                            error:&error];
                                            [self updateViewsWithCallbackResults];
										}
                                        else {
                                            DDLogError(@"something could be wrong...");
                                        }
                                    } failure:^(NSError *error, id response) {
                                        // handle error
                                        DDLogError(@"ERROR: %@", error.localizedDescription);
                                    }];
    DDLogWarn(@"TEST: step++");
}

- (void)updateViewsWithCallbackResults
{
    ([self.forecastModel.unit isKindOfClass:[NSString class]] && [self.forecastModel.unit isEqualToString:@"us"])
    ? (self.degreeSymbolString = @"\u2109")
    : (self.degreeSymbolString = @"\u2103");
    self.weatherSummaryLabel.text = self.forecastModel ? self.forecastModel.currentlySummary : @"";
    self.degreeSymbol.text = [NSString stringWithFormat:@"%.f%@",
                              ceilf(self.forecastModel.currentlyApparentTemperature),
                              self.degreeSymbolString];
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
    self.internetReachability.unreachableBlock = ^(Reachability *reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // reachability status
            // Unreachable
            [[Forecast sharedManager] cancelAllForecastRequests];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"NETWORK ERROR"
                                                                message:@"Internet connection seems unreachable! %@\n%@"
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

@end
