//
//  CMShowsListCMShowsListPresenter.m
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import "CMShowsListPresenter.h"
#import "CMShowsListCollectionPresenter.h"
#import "CMAPIShowList.h"
#import "CMCammentsInStreamPlayerWireframe.h"
#import "CMShowsListWireframe.h"
#import "CMShow.h"
#import "CMStore.h"
#import "CammentSDK.h"
#import "GVUserDefaults.h"
#import "GVUserDefaults+CammentSDKConfig.h"
#import "FBTweak.h"
#import "FBTweakCategory.h"
#import "FBTweakCollection.h"
#import "FBTweakStore.h"
#import "ReactiveObjC.h"

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
        [self.interactor fetchShowList:[[GVUserDefaults standardUserDefaults] broadcasterPasscode]];
    }
}

- (void)setupView {
    [self.output setCurrentBroadcasterPasscode:[[GVUserDefaults standardUserDefaults] broadcasterPasscode]];
    [self.output setLoadingIndicator];
    [self.output setCammentsBlockNodeDelegate:self.showsListCollectionPresenter];
    
    NSArray *updateShowsListSignals = @[
                                        RACObserve([CMStore instance], isSignedIn),
                                        RACObserve([CMStore instance], isConnected),
                                        RACObserve([CMStore instance], isOfflineMode)
                                        ];
    [[[RACSignal combineLatest:updateShowsListSignals] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        NSNumber *isSignedIn = tuple.first;
        NSNumber *isOfflineMode = tuple.third;
        
        if (isSignedIn.boolValue || isOfflineMode.boolValue) {
            [self.interactor fetchShowList:[[GVUserDefaults standardUserDefaults] broadcasterPasscode]];
        }
    }];
}

- (void)updateShows:(NSString *)passcode {
    [self.output hideLoadingIndicator];
    [[GVUserDefaults standardUserDefaults] setBroadcasterPasscode:passcode];
    [self.output setCurrentBroadcasterPasscode:[[GVUserDefaults standardUserDefaults] broadcasterPasscode]];
    [self.output setLoadingIndicator];
    [self.interactor fetchShowList:passcode];
}

- (void)showListDidFetched:(CMAPIShowList *)list {
    NSArray *shows = [list.items.rac_sequence map:^CMShow *(CMAPIShow *value) {
        return [[CMShow alloc] initWithUuid:value.uuid url:value.url thumbnail:value.thumbnail showType:[CMShowType videoWithShow:value]];
    }].array ?: @[];

#ifdef USE_INTERNAL_FEATURES
    NSString *demoWebShowUrl;

    if ([CMStore instance].isOfflineMode) {
        demoWebShowUrl = [NSURL fileURLWithPath:[[NSBundle cammentSDKBundle]
                pathForResource:@"page"
                         ofType:@"htm"
                    inDirectory:@"www"]].absoluteString;
    } else {
        FBTweakCollection *collection = [[[FBTweakStore sharedInstance] tweakCategoryWithName:@"Predefined stuff"]
                tweakCollectionWithName:@"Web settings"];

        NSString *tweakName = @"Web page url";
        FBTweak *webShowTweak = [collection tweakWithIdentifier:tweakName];

        demoWebShowUrl = webShowTweak.currentValue;
    }

    shows = [shows arrayByAddingObjectsFromArray:@[
            [[CMShow alloc] initWithUuid:[[NSUUID new] UUIDString]
                                     url:demoWebShowUrl
                               thumbnail:nil
                                showType:[CMShowType htmlWithWebURL:demoWebShowUrl]]
    ]];
#endif

    self.showsListCollectionPresenter.shows = shows;
    [self.showsListCollectionPresenter.collectionNode reloadData];
    [self.output hideLoadingIndicator];
}

- (void)tweakDidChange:(FBTweak *)tweak {
    if ([tweak.name isEqualToString:@"Web page url"]) {
        NSArray *shows = [self.showsListCollectionPresenter.shows.rac_sequence filter:^BOOL(CMShow *value) {
            __block BOOL webShow = NO;
            [value.showType matchVideo:^(CMAPIShow *show) {
                webShow = NO;
            }                     html:^(NSString *webURL) {
                webShow = YES;
            }];
            return !webShow;
        }].array ?: @[];

        self.showsListCollectionPresenter.shows = [shows arrayByAddingObjectsFromArray:@[
                [[CMShow alloc] initWithUuid:[(CMAPIShow *) shows.firstObject uuid]
                                         url:tweak.currentValue
                                   thumbnail:nil
                                    showType:[CMShowType htmlWithWebURL:tweak.currentValue]]
        ]];
        [self.showsListCollectionPresenter.collectionNode reloadData];
    }
}

- (void)showListFetchingFailed:(NSError *)error {
    //if (error.code = )
    DDLogError(@"Show list fetch error %@", error);
}

- (void)didSelectShow:(CMShow *)show {
    CMCammentsInStreamPlayerWireframe *cammentsInStreamPlayerWireframe = [[CMCammentsInStreamPlayerWireframe alloc] initWithShow:show];
    [cammentsInStreamPlayerWireframe presentInViewController:_wireframe.view];
}

- (void)didAcceptInvitationToShow:(CMShowMetadata *)metadata {
    if (!metadata || !metadata.uuid || metadata.uuid.length == 0) { return; }

    NSArray<CMShow *> *shows = [self.showsListCollectionPresenter.shows.rac_sequence filter:^BOOL(CMShow *value) {
        return [value.uuid isEqualToString:metadata.uuid];
    }].array ?: @[];
    CMShow *show = shows.firstObject;
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
