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
#import "CMStore.h"
#import "CammentSDK.h"
#import <FBTweak.h>
#import <FBTweakCategory.h>
#import <FBTweakCollection.h>
#import <FBTweakStore.h>
#import <ReactiveObjC.h>

@interface CMShowsListPresenter () <CMShowsListCollectionPresenterOutput, FBTweakObserver, CMCammentSDKDelegate>

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
        [CammentSDK instance].sdkDelegate = self;
    }

    return self;
}

- (void)networkDidBecomeAvailable {
    if ([CMStore instance].isSignedIn) {
        [self.output setLoadingIndicator];
        [self.interactor fetchShowList];
    }
}

- (void)setupView {
    [self.output setLoadingIndicator];
    [self.output setCammentsBlockNodeDelegate:self.showsListCollectionPresenter];
    [[RACObserve([CMStore instance], isSignedIn) deliverOnMainThread] subscribeNext:^(NSNumber *isSignedIn) {
        if (isSignedIn.boolValue) {
            [self.interactor fetchShowList];
        }
    }];
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
            }                     html:^(NSString *webURL) {
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
    //if (error.code = )
    DDLogError(@"Show list fetch error %@", error);
}

- (void)didSelectShow:(Show *)show {
    CMCammentsInStreamPlayerWireframe *cammentsInStreamPlayerWireframe = [[CMCammentsInStreamPlayerWireframe alloc] initWithShow:show];
    [cammentsInStreamPlayerWireframe presentInViewController:_wireframe.view];
}

- (void)didAcceptInvitationToShow:(CMShowMetadata *)metadata {
    NSArray<Show *> *shows = [self.showsListCollectionPresenter.shows.rac_sequence filter:^BOOL(Show *value) {
        return [value.uuid isEqualToString:metadata.uuid];
    }].array ?: @[];
    Show *show = shows.firstObject;
    if (show) {
        UIViewController *viewController = (id) self.output;
        UIViewController *presentingViewController = viewController;
        if (presentingViewController.presentingViewController) {
            [presentingViewController dismissViewControllerAnimated:YES
                                                         completion:^{
                                                             [self didSelectShow:show];
                                                         }];
        } else {
            [self didSelectShow:show];
        }
    }
}

@end
