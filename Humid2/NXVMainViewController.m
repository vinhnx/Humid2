//
//  NXVMainViewController.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/17/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "NXVMainViewController.h"
#import "NXVForecastModel.h"

// testing location lat and long coordinate keys
static double kNXVLocationLatitude = 10.7574;
static double kNXVLocationLongitude = 106.6734;

@interface NXVMainViewController ()
@property (nonatomic, strong) NXVForecastModel *forecastModel;
@property (nonatomic, copy  ) NSString         *degreeSymbolString;
@property (nonatomic, strong) Reachability     *internetReachability;
@property (nonatomic, assign) BOOL             connectionAvailable;
@end

@implementation NXVMainViewController

#pragma mark - View Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Humid", nil);
        self.degreeSymbolString = @"\u00b0";
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

#pragma mark - Instance Methods

- (void)showDetailedWeatherForecastInfo
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - Private Methods

- (void)setupForecastInfo
{
    Forecast *forecastManager = [Forecast sharedManager];
    forecastManager.APIKey = @""._7._2.c.a._4._8.d._8.b.d._7.d._4.d._1._4._7.b.e.b.f._1.c._8.f.b._9._5._1.f.e._7;

    // TODO: implement a LocationHelper protocol?!

    // #1, using Location's lat & longi coord
    /*
    @weakify(self);
    [forecastManager getForecastForLatitude:kNXVLocationLatitude
                                  longitude:kNXVLocationLongitude
                                    success:^(id JSON) {
                                        @strongify(self);
                                        if (JSON) {
                                            NSError *error = nil;
                                            NXVForecastModel *forecast = [MTLJSONAdapter modelOfClass:[NXVForecastModel class]
                                                                                   fromJSONDictionary:(NSDictionary *)JSON
                                                                                                error:&error];
                                            if (forecast) {
                                                DDLogInfo(@"currently summary: %@", forecast.currentlySummary);
                                                self.weatherSummaryLabel.text = forecast.currentlySummary;
                                                self.degreeSymbolString = @"\u00b0";
                                                ([self.forecastModel.unit isKindOfClass:[NSString class]] && [self.forecastModel.unit
                                                                                      isEqualToString:@"us"])
                                                ? (self.degreeSymbolString = @"\u2109")
                                                : (self.degreeSymbolString = @"\u2103");
                                                self.degreeSymbol.text = [NSString stringWithFormat:@"%.f%@", floorf(forecast.currentlyApparentTemperature), self.degreeSymbolString];
                                            }
                                        }
                                    } failure:^(NSError *error, id response) {
                                        if (error) {
                                            // handle error
                                            DDLogError(@"%@", error.localizedDescription);
                                        }
                                    }];
    */

    // #2, using Forecast+CLLocation category
    CLLocation *location = [[CLLocation alloc] initWithLatitude:kNXVLocationLatitude
                                                      longitude:kNXVLocationLongitude];
    @weakify(self);
    [forecastManager getForecastForLocation:location
                                    success:^(id JSON) {
                                        @strongify(self);
                                        if (JSON) {
                                            NSError *error = nil;
                                            NXVForecastModel *forecast = [MTLJSONAdapter modelOfClass:[NXVForecastModel class]
                                                                                   fromJSONDictionary:(NSDictionary *)JSON
                                                                                                error:&error];
                                            if (forecast) {
                                                self.weatherSummaryLabel.text = forecast.currentlySummary;
                                                ([self.forecastModel.unit isKindOfClass:[NSString class]] && [self.forecastModel.unit
                                                                                                              isEqualToString:@"us"])
                                                ? (self.degreeSymbolString = @"\u2109")
                                                : (self.degreeSymbolString = @"\u2103");
                                                self.degreeSymbol.text = [NSString stringWithFormat:@"%.f%@",
                                                                          floorf(forecast.currentlyApparentTemperature),
                                                                          self.degreeSymbolString];
                                            }

                                            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                                  action:@selector(showDetailedWeatherForecastInfo)];
                                            tap.numberOfTapsRequired = 1;
                                            [self.view addGestureRecognizer:tap];

                                            DDLogWarn(@"TEST: currently summary: %@", forecast.currentlySummary);
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
