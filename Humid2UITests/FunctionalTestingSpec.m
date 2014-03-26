//
//  FunctionalTestingSpec.m
//  Humid2
//
//  Created by Vinh Nguyen on 3/26/14.
//  Copyright 2014 Vinh Nguyen. All rights reserved.
//

#import "Kiwi+KIF.h"

KIF_SPEC_BEGIN(FunctionalTestingSpec)

describe(@"when view did fully loaded", ^{
    context(@"it should setup precedent procedures", ^{
        beforeAll(^{
            [tester usingTimeout:3]; // time out before doing anything (or before testing)
        });

        beforeEach(^{
            [tester usingTimeout:1];
        });
    });

    context(@"it should be able to tap on things", ^{
        it(@"it should be able to tap info", ^{
            [[tester usingTimeout:3] waitForViewWithAccessibilityLabel:NSLocalizedString(@"ShowInfo", @"")];
            [tester tapViewWithAccessibilityLabel:NSLocalizedString(@"ShowInfo", @"")];
        });

        it(@"it should be able to tap main view", ^{
            [[tester usingTimeout:1] waitForViewWithAccessibilityLabel:NSLocalizedString(@"MainView", @"")];
            [tester tapViewWithAccessibilityLabel:NSLocalizedString(@"MainView", @"")];
        });
    });
    
    afterAll(^{ // complete works
        [tester waitForTimeInterval:.7];
	});
});
KIF_SPEC_END

