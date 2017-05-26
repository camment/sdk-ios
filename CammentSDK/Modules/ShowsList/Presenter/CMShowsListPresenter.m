//
//  CMShowsListCMShowsListPresenter.m
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import "CMShowsListPresenter.h"
#import "CMShowsListCollectionPresenter.h"
#import "CMShowList.h"
#import "CMCammentsInStreamPlayerWireframe.h"
#import "CMShowsListWireframe.h"

@interface CMShowsListPresenter () <CMShowsListCollectionPresenterOutput>
@property(nonatomic, strong) CMShowsListCollectionPresenter *showsListCollectionPresenter;
@end

@implementation CMShowsListPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.showsListCollectionPresenter = [CMShowsListCollectionPresenter new];
        self.showsListCollectionPresenter.output = self;
    }

    return self;
}

- (void)setupView {
    [self.output setCammentsBlockNodeDelegate:self.showsListCollectionPresenter];
    [self.interactor fetchShowList];
}

- (void)showListDidFetched:(CMShowList *)list {
    self.showsListCollectionPresenter.shows = list.items;
    [self.showsListCollectionPresenter.collectionNode reloadData];
}

- (void)showListFetchingFailed:(NSError *)error {

}

- (void)didSelectShow:(CMShow *)show {
    CMCammentsInStreamPlayerWireframe *cammentsInStreamPlayerWireframe = [[CMCammentsInStreamPlayerWireframe alloc] initWithShow: show];
    [cammentsInStreamPlayerWireframe presentInViewController:_wireframe.view];
}

@end