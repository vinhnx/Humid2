//
//  Humid2Tests.m
//  Humid2Tests
//
//  Created by Vinh Nguyen on 3/17/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

//#import <Specta/Specta.h>
//#define EXP_SHORTHAND
//#import <Expecta/Expecta.h>
#import <Kiwi/Kiwi.h>
#import "NXVForecastModel.h"
//#import <OHHTTPStubs/OHHTTPStubs.h>

// TODO add real test!

SPEC_BEGIN(TestEvaluateForecastData)

beforeEach(^{
//    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
//        // here we can decide whether to stub the request or not,
//        // based for example on the request URL
//        return YES;
//    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
//        // here we can fake the data from our stubbed network call
//        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
//        return [OHHTTPStubsResponse responseWithFileAtPath:[bundle pathForResource:@"forecast" ofType:@"json"]
//                                                statusCode:200
//                                                   headers:@{@"Content-Type": @"application/json"}];
//    }];
});

afterAll(^{
//    [OHHTTPStubs removeAllStubs];
});

SPEC_END
