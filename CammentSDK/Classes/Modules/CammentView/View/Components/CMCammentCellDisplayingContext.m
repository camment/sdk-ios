//
// Created by Alexander Fedosov on 27.11.2017.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMCammentCellDisplayingContext.h"
#import "CMCamment.h"


@implementation CMCammentCellDisplayingContext

- (instancetype)initWithCamment:(CMCamment *)camment shouldShowWatchedStatus:(BOOL)shouldShowWatchedStatus {
    self = [super init];
    if (self) {
        self.camment = camment;
        self.shouldShowWatchedStatus = shouldShowWatchedStatus;
    }

    return self;
}

@end