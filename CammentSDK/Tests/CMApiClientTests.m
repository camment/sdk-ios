//
//  cammentTests.m
//  cammentTests
//
//  Created by Alexander Fedosov on 13.11.2017.
//  Copyright © 2017 Sportacam. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import "CMAPIDevcammentClient.h"

SpecBegin(CMAPIDevcammentClientTests)

describe(@"Api client", ^{
    
    it(@"can be created", ^{
        expect([CMAPIDevcammentClient defaultClient]).toNot.beNil();
    });
});

SpecEnd


