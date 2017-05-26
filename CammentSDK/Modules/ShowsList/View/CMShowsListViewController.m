//
//  CMShowsListCMShowsListViewController.m
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import "CMShowsListViewController.h"


@interface CMShowsListViewController () <ASCollectionDelegate>
@end

@implementation CMShowsListViewController

- (instancetype)init {
    self = [super initWithNode:[CMShowsListNode new]];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.presenter setupView];
}

- (void)setCammentsBlockNodeDelegate:(id <CMShowsListNodeDelegate>)delegate {
    [self.node setShowsListDelegate:delegate];
    [delegate setItemCollectionDisplayNode:self.node];
}

@end
