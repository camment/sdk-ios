//
//  CMCammentViewCMCammentViewPresenter.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import <FBSDKAccessToken.h>
#import <DateTools/DateTools.h>
#import "CMCammentViewPresenter.h"
#import "CMCammentViewWireframe.h"
#import "CMInvitationWireframe.h"
#import "CMPresentationInstructionOutput.h"
#import "CMPresentationPlayerInteractor.h"
#import "CMCammentsBlockPresenter.h"
#import "Show.h"
#import "CMStore.h"
#import "CMCammentRecorderInteractorInput.h"
#import "CMPresentationState.h"
#import "CMCammentsLoaderInteractorInput.h"
#import "FBTweakStore.h"
#import "FBTweakCategory.h"
#import "FBTweakCollection.h"
#import "FBTweak.h"
#import "CMPresentationBuilder.h"
#import "CMPresentationUtility.h"
#import "CMCammentUploader.h"
#import "CMCammentInRequest.h"
#import "CMDevcammentClient.h"
#import "CMAuthInteractor.h"
#import "CammentSDK.h"
#import "CammentBuilder.h"

@interface CMCammentViewPresenter () <CMPresentationInstructionOutput, CMAuthInteractorOutput>

@property(nonatomic, strong) CMPresentationPlayerInteractor *presentationPlayerInteractor;
@property(nonatomic, strong) CMAuthInteractor *authInteractor;
@property(nonatomic, strong) CMCammentsBlockPresenter *cammentsBlockNodePresenter;
@property(nonatomic, strong) Show *show;
@property(nonatomic, strong) UsersGroup *usersGroup;
@property(nonatomic, assign) BOOL isOnboardingRunning;

@end

@implementation CMCammentViewPresenter

- (instancetype)initWithShow:(Show *)show {
    self = [super init];

    if (self) {
        self.show = show;
        self.cammentsBlockNodePresenter = [CMCammentsBlockPresenter new];
        self.presentationPlayerInteractor = [CMPresentationPlayerInteractor new];
        self.authInteractor = [CMAuthInteractor new];
        self.authInteractor.output = self;
        self.presentationPlayerInteractor.instructionOutput = self;
        self.usersGroup = [CMStore instance].activeGroup;
        @weakify(self);
        [RACObserve([CMStore instance], activeGroup) subscribeNext:^(UsersGroup *group) {
            @strongify(self);
            self.usersGroup = group;
        }];

        [RACObserve([CMStore instance], playingCammentId) subscribeNext:^(NSString *nextId) {
            @strongify(self);
            [self playCamment:nextId];
            if (self.isOnboardingRunning && [nextId isEqualToString:kCMStoreCammentIdIfNotPlaying]) {
                [self completeActionForOnboardingAlert:CMOnboardingAlertTapToPlayCamment];
            }
        }];

        [[[RACObserve([CMStore instance], cammentRecordingState) filter:^BOOL(NSNumber *state) {
            return state.integerValue != CMCammentRecordingStateNotRecording;
        }] flattenMap:^RACSignal *(NSNumber *state) {
            @strongify(self);
            if (!self) {return [RACSignal empty];}
            CMCammentRecordingState cammentRecordingState = (CMCammentRecordingState) state.integerValue;

            if (cammentRecordingState == CMCammentRecordingStateFinished) {
                [self.recorderInteractor stopRecording];
                return [RACSignal empty];
            }

            if (cammentRecordingState == CMCammentRecordingStateCancelled) {
                [[CMStore instance] setPlayingCammentId:kCMStoreCammentIdIfNotPlaying];
                [self.recorderInteractor cancelRecording];
                return [RACSignal empty];
            }

            return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
                [subscriber sendNext:@YES];
                return nil;
            }] delay:0.0f];
        }] subscribeNext:^(id x) {
            [[CMStore instance] setPlayingCammentId:kCMStoreCammentIdIfNotPlaying];
            [self.recorderInteractor startRecording];
        }];

        [[RACSignal combineLatest:@[
                RACObserve(self, cammentsBlockNodePresenter.items),
                RACObserve([CMStore instance], currentShowTimeInterval)
        ]] subscribeNext:^(RACTuple *tuple) {
            @strongify(self);
            if (!self) {return;}
            CMPresentationState *state = [CMPresentationState new];
            state.items = tuple.first;
            state.timestamp = [tuple.second unsignedIntegerValue];
            [self.presentationPlayerInteractor update:state];
        }];
    }

    return self;
}

- (void)setupView {
    [self.recorderInteractor configureCamera];
    [self.output presenterDidRequestViewPreviewView];
    [self.output setCammentsBlockNodeDelegate:_cammentsBlockNodePresenter];
    [self updateChatWithActiveGroup];
}

- (void)readyToShowOnboarding {
    [self runOnboarding];
}

- (void)runOnboarding {
    _isOnboardingRunning = YES;
    [self.output showOnboardingAlert:CMOnboardingAlertTapAndHoldToRecordTooltip];
}

- (void)updateChatWithActiveGroup {
    _cammentsBlockNodePresenter.items = @[];
    [self reloadCamments];
    [self.loaderInteractor fetchCachedCamments:self.usersGroup.uuid];
    [self setupPresentationInstruction];
}

- (void)updateCameraOrientation:(AVCaptureVideoOrientation)orientation {
    [self.recorderInteractor updateDeviceOrientation:orientation];
}

- (UIInterfaceOrientationMask)contentPossibleOrientationMask {
    __block UIInterfaceOrientationMask mask;

    [self.show.showType matchVideo:^(CMShow *show) {
        mask = UIInterfaceOrientationMaskLandscapeRight;
    }                         html:^(NSString *webURL) {
        mask = UIInterfaceOrientationMaskPortrait;
    }];

    return mask;
}

- (void)setupPresentationInstruction {
    NSString *scenario = [[[[[FBTweakStore sharedInstance] tweakCategoryWithName:@"Predefined stuff"] tweakCollectionWithName:@"Demo"] tweakWithIdentifier:@"Scenario"] currentValue] ?: @"None";

    id <CMPresentationBuilder> builder = nil;

    NSArray<id <CMPresentationBuilder>> *presentations = [CMPresentationUtility activePresentations];
    for (id <CMPresentationBuilder> presentation in presentations) {
        if ([[presentation presentationName] isEqualToString:scenario]) {
            builder = presentation;
        }
    }

    if (!builder) {
        return;
    }
    self.presentationPlayerInteractor.instructions = [builder instructions];
}

- (void)reloadCamments {
    [_cammentsBlockNodePresenter.collectionNode reloadData];
}

- (void)didFetchCamments:(NSArray<Camment *> *)camments {
    _cammentsBlockNodePresenter.items = [camments.rac_sequence map:^id(Camment *value) {
        return [CammentsBlockItem cammentWithCamment:value];
    }].array;
    [self reloadCamments];
}

- (void)playCamment:(NSString *)cammentId {
    [_cammentsBlockNodePresenter playCamment:cammentId];
}

- (void)connectPreviewViewToRecorder:(SCImageView *)view {
    [_recorderInteractor connectPreviewViewToRecorder:view];
}

- (void)recorderDidFinishAVAsset:(AVAsset *)asset uuid:(NSString *)uuid {
    if (asset) {
        if (CMTimeGetSeconds(asset.duration) < 0.3) {return;}
        NSString *groupUUID = [self.usersGroup uuid];
        Camment *camment = [[Camment alloc] initWithShowUuid:self.show.uuid
                                               userGroupUuid:groupUUID
                                                        uuid:uuid
                                                   remoteURL:nil
                                                    localURL:nil
                                                thumbnailURL:nil
                                                  localAsset:asset];
        [self.cammentsBlockNodePresenter insertNewItem:[CammentsBlockItem cammentWithCamment:camment]
                                            completion:^{
                                                if (self.isOnboardingRunning) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [self.output showOnboardingAlert:CMOnboardingAlertTapToPlayCamment];
                                                    });
                                                }
                                            }];
    }
}

- (void)recorderDidFinishExportingToURL:(NSURL *)url uuid:(NSString *)uuid {

    RACSignal<UsersGroup *> *verifyUserGroup = nil;

    if (self.usersGroup) {
        verifyUserGroup = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
            [subscriber sendNext:self.usersGroup];
            return nil;
        }];
    } else {
        verifyUserGroup = [[self.interactor createEmptyGroup] doNext:^(UsersGroup *x) {
            [[CMStore instance] setActiveGroup:x];
        }];
    }

    [[[verifyUserGroup flattenMap:^RACSignal *(UsersGroup *groupToSend) {
        Camment *cammentToUpload = [[[[[[CammentBuilder new] withUuid:uuid]
                withLocalURL:url.absoluteString]
                withShowUuid:self.show.uuid]
                withUserGroupUuid:groupToSend.uuid]
                build];
        return [self.interactor uploadCamment:cammentToUpload];
    }] deliverOnMainThread] subscribeNext:^(Camment *uploadedCamment) {
        NSMutableArray<CammentsBlockItem *> *mutableCamments = [self.cammentsBlockNodePresenter.items mutableCopy];
        NSInteger index = [self.cammentsBlockNodePresenter.items indexOfObjectPassingTest:^BOOL(CammentsBlockItem *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            __block BOOL result = NO;

            [obj matchCamment:^(Camment *camment) {
                result = [camment.uuid isEqualToString:uploadedCamment.uuid];
            }             ads:^(Ads *ads) {
            }];

            return result;
        }];

        if (index != NSNotFound) {
            CammentsBlockItem *cammentsBlockItem = mutableCamments[(NSUInteger) index];
            [cammentsBlockItem matchCamment:^(Camment *camment) {
                mutableCamments[(NSUInteger) index] = [CammentsBlockItem cammentWithCamment:uploadedCamment];
            }                           ads:^(Ads *ads) {
            }];
        }
        self.cammentsBlockNodePresenter.items = mutableCamments.copy;
    }                               error:^(NSError *error) {

    }];
}

- (void)didReceiveNewCamment:(Camment *)camment {

    NSArray *filteredItemsArray = [self.cammentsBlockNodePresenter.items.rac_sequence filter:^BOOL(CammentsBlockItem *value) {
        __block BOOL result = NO;

        [value matchCamment:^(Camment *mathedCamment) {
            result = [camment.uuid isEqualToString:mathedCamment.uuid];
        }               ads:^(Ads *ads) {
        }];

        return result;
    }].array ?: @[];

    BOOL isNewItem = filteredItemsArray.count == 0;

    if (
            ([camment.userGroupUuid isEqualToString:[self.usersGroup uuid]]
                    || [camment.showUuid isEqualToString:kCMPresentationBuilderUtilityAnyShowUUID])
                    &&
                    isNewItem
            ) {
        [self.cammentsBlockNodePresenter insertNewItem:[CammentsBlockItem cammentWithCamment:camment] completion:^{
        }];
    }
}

- (void)didReceiveNewAds:(Ads *)ads {
    [self.cammentsBlockNodePresenter insertNewItem:[CammentsBlockItem adsWithAds:ads] completion:^{
    }];
}

- (void)inviteFriendsAction {
    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    [CMStore instance].isFBConnected = token != nil && [token.expirationDate laterDate:[NSDate date]];
    if ([CMStore instance].isFBConnected) {
        [[CMInvitationWireframe new] presentInViewController:self.wireframe.parentViewController];
    } else {
        [self.output showLoadingHUD];
        [_authInteractor signInWithFacebookProvider:(id) self.output];
    }
}

- (void)authInteractorDidSignedIn {
    CMCammentFacebookIdentity *fbIdentity = [CMCammentFacebookIdentity identityWithFBSDKAccessToken:[FBSDKAccessToken currentAccessToken]];
    [[CammentSDK instance] connectUserWithIdentity:fbIdentity
                                           success:^{
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [self.output hideLoadingHUD];
                                                   [self inviteFriendsAction];
                                               });
                                           }
                                             error:^(NSError *error) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     [self.output hideLoadingHUD];
                                                 });
                                                 NSLog(@"Error %@", error);
                                             }];
}

- (void)authInteractorFailedToSignIn:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.output hideLoadingHUD];
    });
    NSLog(@"Error %@", error);
}

- (void)completeActionForOnboardingAlert:(CMOnboardingAlertType)type {
    [self.output hideOnboardingAlert:type];
    switch (type) {

        case CMOnboardingAlertNone:
            break;
        case CMOnboardingAlertWouldYouLikeToChatAlert:break;
        case CMOnboardingAlertWhatIsCammentTooltip:break;
        case CMOnboardingAlertTapAndHoldToRecordTooltip:
            break;
        case CMOnboardingAlertSwipeLeftToHideCammentsTooltip:
            [self.output showOnboardingAlert:CMOnboardingAlertSwipeRightToShowCammentsTooltip];
            break;
        case CMOnboardingAlertSwipeRightToShowCammentsTooltip:
            break;
        case CMOnboardingAlertSwipeDownToInviteFriendsTooltip:break;
        case CMOnboardingAlertTapAndHoldToDeleteCammentsTooltip:break;
        case CMOnboardingAlertTapToPlayCamment:
            [self.output showOnboardingAlert:CMOnboardingAlertSwipeLeftToHideCammentsTooltip];
            break;
    }
}

- (void)cancelActionForOnboardingAlert:(CMOnboardingAlertType)type {

}

@end
