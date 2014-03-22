//
//  NXVMainViewController.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/17/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "NXVMainViewController.h"
#import "NXVForecastModel.h"

@interface NXVMainViewController ()
@property (nonatomic, strong) NXVForecastModel *forecastModel;
@property (nonatomic, copy) NSString *degreeSymbolString;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Instance Methods

- (IBAction)showForecastInfo:(id)sender
{

}

#pragma mark - Private Methods

- (void)setupForecastInfo
{
    Forecast *forecastManager = [Forecast sharedManager];
    forecastManager.APIKey = @""._7._2.c.a._4._8.d._8.b.d._7.d._4.d._1._4._7.b.e.b.f._1.c._8.f.b._9._5._1.f.e._7;
    [forecastManager getForecastForLatitude:10.7574
                                  longitude:106.6734
                                    success:^(id JSON) {
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

}

@end
