//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerPresenter.m
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import "CMCammentsInStreamPlayerPresenter.h"
#import "CMShow.h"

@interface CMCammentsInStreamPlayerPresenter ()

@property(nonatomic, strong) CMShow *show;

@end

@implementation CMCammentsInStreamPlayerPresenter

- (instancetype)initWithShow:(CMShow *)show {
    self = [super init];

    if (self) {
        self.show = show;
    }

    return self;
}

- (void)setupView {
    [self.output startShow:_show];
}

@end
