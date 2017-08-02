//
// Created by Alexander Fedosov on 01.08.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMDisplayCammentPresentationAction.h"
#import "CammentsBlockItem.h"
#import "CMCammentsLoaderInteractorOutput.h"
#import "CMPresentationInstructionOutput.h"

@interface CMDisplayCammentPresentationAction ()
@property(nonatomic, strong) CammentsBlockItem *item;
@end

@implementation CMDisplayCammentPresentationAction

- (instancetype)initWithItem:(CammentsBlockItem *)item {
    self = [super init];
    if (self) {
        self.item = item;
    }

    return self;
}

- (void)runWithOutput:(id <CMPresentationInstructionOutput>)output {
    [self.item matchCamment:^(Camment *camment) {
        [output didReceiveNewCamment:camment];
    } ads:^(Ads *ads) {
        [output didReceiveNewAds:ads];
    }];
}

@end