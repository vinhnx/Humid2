//
//  Humid2Tests.m
//  Humid2Tests
//
//  Created by Vinh Nguyen on 3/17/14.
//  Copyright (c) 2014 Vinh Nguyen. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

// TODO add real test!

SpecBegin(Thing)

describe(@"Something cool", ^{
    it(@"does mind blowing", ^{
        expect(1).to.equal(1);
    });
});

SpecEnd
