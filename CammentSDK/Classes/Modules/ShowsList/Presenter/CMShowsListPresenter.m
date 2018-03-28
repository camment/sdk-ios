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
#import "CMErrorWireframe.h"
#import "CMUserSessionController.h"

@interface CMShowsListPresenter () <CMShowsListCollectionPresenterOutput, FBTweakObserver, CMCammentSDKDelegate>

@property(nonatomic, strong) CMShowsListCollectionPresenter *showsListCollectionPresenter;

@property(nonatomic, strong) CMCammentsInStreamPlayerWireframe *cammentsInStreamPlayerWireframe;
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
    if ([CMUserSessionController instance].userAuthentificationState) {
        [self.output setLoadingIndicator];
        [self.interactor fetchShowList:[[GVUserDefaults standardUserDefaults] broadcasterPasscode]];
    }
}

- (void)setupView {
    [self.output setCurrentBroadcasterPasscode:[[GVUserDefaults standardUserDefaults] broadcasterPasscode]];
    [self.output setLoadingIndicator];
    [self.output setCammentsBlockNodeDelegate:self.showsListCollectionPresenter];

    NSArray *signals = @[
            RACObserve([CMStore instance], isOfflineMode),
            [CMStore instance].authentificationStatusSubject,
            RACObserve([CMStore instance], awsServicesConfigured),
    ];

    @weakify(self);
    [[[[RACSignal combineLatest:signals]
            takeUntil:self.rac_willDeallocSignal] deliverOnMainThread]
            subscribeNext:^(RACTuple *_Nullable tuple) {
                @strongify(self);
                BOOL isOffline = [tuple.first boolValue];
                CMAuthStatusChangedEventContext *context = tuple.second;
                NSNumber *awsServicesConfigured = tuple.third;
                if (isOffline || (context.state != CMCammentUserNotAuthentificated && [awsServicesConfigured boolValue])) {
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

- (void)viewWantsRefreshShowList {
    [self.interactor fetchShowList:[[GVUserDefaults standardUserDefaults] broadcasterPasscode]];
}

- (void)showListDidFetched:(CMAPIShowList *)list {
    NSArray *shows = [list.items.rac_sequence map:^CMShow *(CMAPIShow *value) {
        return [[CMShow alloc] initWithUuid:value.uuid
                                        url:value.url
                                  thumbnail:value.thumbnail
                                   showType:[CMShowType videoWithShow:value]
                                   startsAt:value.startAt];
    }].array ?: @[];

    self.showsListCollectionPresenter.showNoShowsNode = shows.count == 0;
    self.showsListCollectionPresenter.shows = shows;
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
                                    showType:[CMShowType htmlWithWebURL:tweak.currentValue]
                                    startsAt:nil]
        ]];
        [self.showsListCollectionPresenter.collectionNode reloadData];
    }
}

- (void)showListFetchingFailed:(NSError *)error {
    [[CMErrorWireframe new] presentErrorViewWithError:error
                                     inViewController:(id) self.output];
    DDLogError(@"Show list fetch error %@", error);
    [self.output hideLoadingIndicator];
}

- (void)didSelectShow:(CMShow *)show rect:(CGRect)rect image:(UIImage *)image {
    self.wireframe.view.selectedCellFrame = rect;
    self.wireframe.view.selectedShowPlaceHolder = image;
    [self openShowIfNeeded:show];
}

- (void)showTweaksView {
    [self.output showTweaks];
}

- (void)showPasscodeView {
    [self.output showPasscodeAlert];
}

- (void)openShowIfNeeded:(CMShow *)show {
    if ([self.cammentsInStreamPlayerWireframe.show.uuid isEqualToString:show.uuid] && self.cammentsInStreamPlayerWireframe.view) { return; }

    if (self.cammentsInStreamPlayerWireframe.view) {
        [self.cammentsInStreamPlayerWireframe.view dismissViewControllerAnimated:YES completion:^{
            self.cammentsInStreamPlayerWireframe = nil;
            [self openShowIfNeeded:show];
            return;
        }];
    }

    self.cammentsInStreamPlayerWireframe = [[CMCammentsInStreamPlayerWireframe alloc] initWithShow:show];
    [_cammentsInStreamPlayerWireframe presentInViewController:_wireframe.view];
}

- (void)openShowIfNeededWithMetadata:(CMShowMetadata *_Nonnull)metadata {
    if (!metadata || metadata.uuid.length == 0) {return;}

    NSArray<CMShow *> *shows = [self.showsListCollectionPresenter.shows.rac_sequence filter:^BOOL(CMShow *value) {
        return [value.uuid isEqualToString:metadata.uuid];
    }].array ?: @[];
    CMShow *show = shows.firstObject;

    if (!show) {
        show = [[CMShow alloc] initWithUuid:metadata.uuid
                                        url:nil
                                  thumbnail:nil
                                   showType:nil
                                   startsAt:nil];
    }

    [self openShowIfNeeded:show];
}

- (void)didOpenInvitationToShow:(CMShowMetadata *_Nonnull)metadata {
    [self openShowIfNeededWithMetadata:metadata];
}

- (void)didJoinToShow:(CMShowMetadata *)metadata {
    [self openShowIfNeededWithMetadata:metadata];
}


@end
