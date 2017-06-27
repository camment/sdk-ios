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
#import "FBTweak/FBTweak.h"
#import "FBTweak/FBTweakCategory.h"
#import "FBTweak/FBTweakCollection.h"
#import "FBTweak/FBTweakStore.h"
#import <ReactiveObjC.h>

@interface CMShowsListPresenter () <CMShowsListCollectionPresenterOutput, FBTweakObserver>
@property(nonatomic, strong) CMShowsListCollectionPresenter *showsListCollectionPresenter;
@end

@implementation CMShowsListPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.showsListCollectionPresenter = [CMShowsListCollectionPresenter new];
        self.showsListCollectionPresenter.output = self;

        FBTweakCollection *collection = [[[FBTweakStore sharedInstance] tweakCategoryWithName:@"Predefined stuff"]
                tweakCollectionWithName:@"Web settings"];

        NSString *tweakName = @"Web page url";
        FBTweak *webShowTweak = [collection tweakWithIdentifier:tweakName];
        [webShowTweak addObserver:self];
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

- (void)tweakDidChange:(FBTweak *)tweak {
    if ([tweak.name isEqualToString:@"Web page url"]) {
        NSArray *shows = [self.showsListCollectionPresenter.shows.rac_sequence filter:^BOOL(Show *value) {
            __block BOOL webShow = NO;
            [value.showType matchVideo:^(CMShow *show) {
                webShow = NO;
            } html:^(NSString *webURL) {
                webShow = YES;
            }];
            return !webShow;
        }].array ?: @[];

        self.showsListCollectionPresenter.shows = [shows arrayByAddingObjectsFromArray:@[
                [[Show alloc] initWithUuid:[(CMShow *) shows.firstObject uuid]
                                       url:tweak.currentValue
                                  showType:[ShowType htmlWithWebURL:tweak.currentValue]]
        ]];
        [self.showsListCollectionPresenter.collectionNode reloadData];
    }
}

- (void)showListFetchingFailed:(NSError *)error {

}

- (void)didSelectShow:(Show *)show {
    CMCammentsInStreamPlayerWireframe *cammentsInStreamPlayerWireframe = [[CMCammentsInStreamPlayerWireframe alloc] initWithShow:show];
    [cammentsInStreamPlayerWireframe presentInViewController:_wireframe.parentNavigationController];
}

@end