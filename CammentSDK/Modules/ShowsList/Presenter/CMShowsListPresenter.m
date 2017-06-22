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
#import "Show.h"
#import <FBTweak.h>
#import <FBTweakCategory.h>
#import <FBTweakCollection.h>
#import <FBTweakStore.h>
#import <ReactiveObjC.h>

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
    [self.output setLoadingIndicator];
    [self.output setCammentsBlockNodeDelegate:self.showsListCollectionPresenter];
    [self.interactor fetchShowList];
}

- (void)showListDidFetched:(CMShowList *)list {
    NSArray *shows = [list.items.rac_sequence map:^Show *(CMShow *value) {
        return [[Show alloc] initWithUuid:value.uuid url:value.url showType:[ShowType videoWithShow:value]];
    }].array ?: @[];

    FBTweakCollection *collection = [[[FBTweakStore sharedInstance] tweakCategoryWithName:@"Predefined stuff"]
            tweakCollectionWithName:@"Web settings"];

    NSString *tweakName = @"Web page url";
    FBTweak *webShowTweak = [collection tweakWithIdentifier:tweakName];

    self.showsListCollectionPresenter.shows = [shows arrayByAddingObjectsFromArray:@[
            [[Show alloc] initWithUuid:[(CMShow *) list.items.firstObject uuid]
                                   url:webShowTweak.currentValue
                              showType:[ShowType htmlWithWebURL:webShowTweak.currentValue]]
    ]];
    [self.showsListCollectionPresenter.collectionNode reloadData];
    [self.output hideLoadingIndicator];
}

- (void)showListFetchingFailed:(NSError *)error {

}

- (void)didSelectShow:(Show *)show {
    CMCammentsInStreamPlayerWireframe *cammentsInStreamPlayerWireframe = [[CMCammentsInStreamPlayerWireframe alloc] initWithShow:show];
    [cammentsInStreamPlayerWireframe presentInViewController:_wireframe.parentNavigationController];
}

@end
