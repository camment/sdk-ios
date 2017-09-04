//
// Created by Alexander Fedosov on 01.08.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMDisplayCammentPresentationAction.h"
#import "CMCammentsBlockItem.h"
#import "CMCammentsLoaderInteractorOutput.h"
#import "CMPresentationInstructionOutput.h"

@interface CMDisplayCammentPresentationAction ()
@property(nonatomic, strong) CMCammentsBlockItem *item;
@end

@implementation CMDisplayCammentPresentationAction

- (instancetype)initWithItem:(CMCammentsBlockItem *)item {
    self = [super init];
    if (self) {
        self.item = item;
    }

    return self;
}

- (void)runWithOutput:(id <CMPresentationInstructionOutput>)output {
    [self.item matchCamment:^(CMCamment *camment) {
        [output didReceiveNewCamment:camment];
    } ads:^(CMAds *ads) {
        [output didReceiveNewAds:ads];
    }];
}

@end