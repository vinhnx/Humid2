//
//  WeatherService.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/29/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import "WeatherService.h"

@interface WeatherService ()
@property (nonatomic, strong) AFHTTPSessionManager *session;
@end

@implementation WeatherService

#pragma mark - Object Initialize

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *baseURL = [NSURL URLWithString:self.urlStringPattern];
<<<<<<< HEAD
=======
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
>>>>>>> 3dbb196... Fix missing semicolon in WeatherService
        _session = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL
                                            sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

#pragma mark - Instance Methods

- (void)getWeatherForLatitude:(double)latitude
                    longitude:(double)longitude
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *, id))failure
{
    // IMPORTANT, we have to check if API key was set!
    // else, we raise a NSException flag
    [self checkAPIKey];

    // generate the URL string based on the passed in params
    NSString *urlString = [self URLStringForLatitude:latitude longitude:longitude];

#ifdef DEBUG
    DDLogError(@"...checking weather forecast for %@", urlString);
#endif

    // call GET request on the API for the URL
    [self.session GET:urlString
           parameters:nil
              success:^(NSURLSessionDataTask *task, id JSON) {
                  success(JSON);
              }
              failure:^(NSURLSessionDataTask *task, NSError *error) {
                  NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                  failure(error, response);
                  DDLogError(@"%s. API call error: %@", __PRETTY_FUNCTION__, error.localizedDescription);
              }];
}

- (void)getWeatherForLocation:(CLLocation *)location
                      success:(void (^)(id JSON))success
                      failure:(void (^)(NSError *error, id response))failure
{
    double lat = location.coordinate.latitude;
    double longi = location.coordinate.longitude;
    [self getWeatherForLatitude:lat
                      longitude:longi
                        success:^(id JSON) {
                            success(JSON);
                        }
                        failure:^(NSError *error, id response) {
                            failure(error, response);
                            DDLogError(@"%s. API call error: %@", __PRETTY_FUNCTION__, error.localizedDescription);
                        }];
}

- (void)cancelAllRequests
{
    for (id task in [self.session tasks]) { // loop through all NSURLSession tasks
        if ([task respondsToSelector:@selector(cancel)]) {
            [task cancel];
        }
    }
}

#pragma mark - Private methods

- (void)checkAPIKey
{
    // check for the existence of APIkey
    if (!self.APIKey || !self.APIKey.length) {
		[NSException raise:@"Please check if API key was set up properly."
		            format:@"API not found"];
    }
}

- (NSString *)URLStringForLatitude:(double)latitude longitude:(double)longitude
{
    // Wunderground API call pattern: http://api.wunderground.com/api/APIKEY/conditions/q/LAT,LONGI.json
    // Forecast.io API call pattern: https://api.forecast.io/forecast/APIKEY/LAT,LONGI
    NSString *url = @"";
    if (self.urlStringPattern.length && self.urlStringPattern) {
        url = [NSString stringWithFormat:self.urlStringPattern, self.APIKey, latitude, longitude];
    } else {
<<<<<<< HEAD
        [NSException raise:@"Service URL pattern not found"
                    format:@"Please check your URL set up again."];

=======
        [NSException raise:@"Please check your URL set up again."
                    format:@"Service URL pattern not found."];
>>>>>>> 3dbb196... Fix missing semicolon in WeatherService
    }
	return url;
}

@end
