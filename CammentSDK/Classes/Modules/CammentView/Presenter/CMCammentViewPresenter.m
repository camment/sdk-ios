//
//  CMCammentViewCMCammentViewPresenter.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "CMCammentViewPresenter.h"
#import "CMCammentViewWireframe.h"
#import "CMInvitationWireframe.h"
#import "CMPresentationInstructionOutput.h"
#import "CMPresentationPlayerInteractor.h"
#import "CMShow.h"
#import "CMStore.h"
#import "CMPresentationState.h"
#import "FBTweakStore.h"
#import "FBTweakCategory.h"
#import "FBTweakCollection.h"
#import "CMPresentationBuilder.h"
#import "CMPresentationUtility.h"
#import "CMCammentUploader.h"
#import "CammentSDK.h"
#import "CMCammentBuilder.h"
#import "CMUserJoinedMessage.h"
#import "CMCammentDeletedMessage.h"
#import "CMCammentCell.h"
#import "CMBotRegistry.h"
#import "CMAnalytics.h"
#import "CMErrorWireframe.h"
#import "CMCammentsBlockPresenterInput.h"
#import "CMUserSessionController.h"
#import "CMCammentCellDisplayingContext.h"
#import "CMAdsDemoBot.h"
#import "NSArray+RacSequence.h"
#import "CMVideoSyncInteractor.h"
#import <TBStateMachine/TBSMStateMachine.h>
#import <TBStateMachine/TBSMDebugger.h>

@interface CMCammentViewPresenter () <CMPresentationInstructionOutput>

@property(nonatomic, strong) CMPresentationPlayerInteractor *presentationPlayerInteractor;
@property(nonatomic, strong) id <CMInvitationInteractorInput> invitationInteractor;
@property(nonatomic, strong) id <CMCammentsBlockPresenterInput> cammentsBlockNodePresenter;
@property(nonatomic, weak) RACDisposable *willStartRecordSignal;

@property(nonatomic) BOOL isCameraSessionConfigured;
@property(nonatomic) BOOL onboardingWasStarted;

@property(nonatomic) CMBotRegistry *botRegistry;
@property(nonatomic, strong) TBSMStateMachine *onboardingStateMachine;
@property(nonatomic) BOOL canLoadMoreCamments;
@property(nonatomic, strong) ASBatchContext *cammentBatchContext;
@end

@implementation CMCammentViewPresenter

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"`- init` is not a valid initializer. Use `- initWithShowMetadata:(CMShowMetadata *)metadata\n"
                                           "                      authInteractor:(id <CMAuthInteractorInput>)authInteractor\n"
                                           "                invitationInteractor:(id <CMInvitationInteractorInput>)invitationInteractor\n"
                                           "              cammentsBlockPresenter:(id <CMCammentsBlockPresenterInput>)cammentsBlockPresenter` instead."
                                 userInfo:nil];
    return nil;
}

- (instancetype)initWithShowMetadata:(CMShowMetadata *)metadata
               userSessionController:(CMUserSessionController *)userSessionController
                invitationInteractor:(id <CMInvitationInteractorInput>)invitationInteractor
              cammentsBlockPresenter:(id <CMCammentsBlockPresenterInput>)cammentsBlockPresenter {
    self = [super init];

    if (self) {
        self.cammentsBlockNodePresenter = cammentsBlockPresenter;
        self.presentationPlayerInteractor = [CMPresentationPlayerInteractor new];
        self.userSessionController = userSessionController;
        self.invitationInteractor = invitationInteractor;

        self.presentationPlayerInteractor.instructionOutput = self;

        self.botRegistry = [CMBotRegistry new];
        [self.botRegistry addBot:[CMAdsDemoBot new]];
        [self.botRegistry updateBotsOutputInterface:self];

        [self setupOnboardingStateMachine];
        
        __weak typeof(self) weakSelf = self;
        @weakify(self);
        [[[[[CMStore instance] fetchUpdatesSubject] takeUntil:self.rac_willDeallocSignal] deliverOnMainThread] subscribeNext:^(NSNumber *shouldReload) {
            @strongify(self);
            if (shouldReload.boolValue) {
                [self updateCammentsAfterConnectionHasRestored];
                [[CMVideoSyncInteractor new] requestNewShowTimestampIfNeeded:[CMStore instance].activeGroup.uuid];
            }
        }];

        [[[[[CMStore instance] reloadActiveGroupSubject] takeUntil:self.rac_willDeallocSignal] deliverOnMainThread] subscribeNext:^(NSNumber *shouldReload) {
            @strongify(self);
            if (shouldReload.boolValue) {
                [self updateChatWithActiveGroup];
            }
        }];

        [[[[[CMStore instance] inviteFriendsActionSubject] takeUntil:self.rac_willDeallocSignal] deliverOnMainThread] subscribeNext:^(NSNumber *shouldReload) {
            @strongify(self);
            [self inviteFriendsAction];
        }];

        [[[[[CMStore instance] startTutorial] takeUntil:self.rac_willDeallocSignal] deliverOnMainThread] subscribeNext:^(NSNumber *shouldReload) {
            @strongify(self);
            [self sendOnboardingEvent:CMOnboardingEvent.Started];
        }];

        [[[RACObserve([CMStore instance], playingCammentId)
                takeUntil:self.rac_willDeallocSignal]
                deliverOnMainThread]
                subscribeNext:^(NSString *nextId) {
                    @strongify(self);
                    [self playCamment:nextId];
                    if (![nextId isEqualToString:kCMStoreCammentIdIfNotPlaying]) {
                        [self sendOnboardingEvent:CMOnboardingEvent.CammentPlayed];
                    }

                }];

        [[[[RACObserve([CMStore instance], cammentRecordingState) takeUntil:self.rac_willDeallocSignal]
                filter:^BOOL(NSNumber *state) {
                    switch ((CMCammentRecordingState) state.integerValue) {
                        case CMCammentRecordingStateNotRecording:
                            break;
                        case CMCammentRecordingStateRecording:
                            break;
                        case CMCammentRecordingStateFinished:
                            [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventCammentRecord];
                            break;
                        case CMCammentRecordingStateCancelled:
                            break;
                    }
                    return state.integerValue != CMCammentRecordingStateNotRecording;
                }] flattenMap:^RACSignal *(NSNumber *state) {

            if (!weakSelf) {return [RACSignal empty];}
            CMCammentRecordingState cammentRecordingState = (CMCammentRecordingState) state.integerValue;

            if (cammentRecordingState == CMCammentRecordingStateFinished) {
                [weakSelf.willStartRecordSignal dispose];
                [weakSelf.recorderInteractor stopRecording];
                return [RACSignal empty];
            }

            if (cammentRecordingState == CMCammentRecordingStateCancelled) {
                [weakSelf.willStartRecordSignal dispose];
                [[CMStore instance] setPlayingCammentId:kCMStoreCammentIdIfNotPlaying];
                [weakSelf.recorderInteractor cancelRecording];
                return [RACSignal empty];
            }

            return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
                [subscriber sendNext:@YES];
                return nil;
            }];
        }] subscribeNext:^(id x) {
            if (!weakSelf.isCameraSessionConfigured) {
                [weakSelf.output askForSetupPermissions];
                return;
            }

            [[CMStore instance] setPlayingCammentId:kCMStoreCammentIdIfNotPlaying];
            weakSelf.willStartRecordSignal = [[[[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
                [subscriber sendCompleted];
                return nil;
            }] delay:0.5] deliverOnMainThread] subscribeCompleted:^{
                [weakSelf.recorderInteractor startRecording];
            }];
        }];

        [[[[RACSignal combineLatest:@[
                RACObserve(self.cammentsBlockNodePresenter, items),
                RACObserve([CMStore instance], currentShowTimeInterval)
        ]]
                takeUntil:self.rac_willDeallocSignal]
                deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityLow
                                                         name:@"track video player time changes"]]
                subscribeNext:^(RACTuple *tuple) {
                    @strongify(self);
                    if (!self) {return;}
                    CMPresentationState *state = [CMPresentationState new];
                    state.items = tuple.first;
                    state.timestamp = [tuple.second unsignedIntegerValue];
                    [self.presentationPlayerInteractor update:state];
                }];

        [[[[[CMStore instance] cleanUpSignal] takeUntil:self.rac_willDeallocSignal] deliverOnMainThread] subscribeNext:^(NSNumber *cleanUp) {
            @strongify(self);
            [self.cammentsBlockNodePresenter reloadItems:@[] animated:YES];
        }];

        [self.rac_willDeallocSignal subscribeCompleted:^{
            [CMStore instance].lastTimestampUploaded = nil;
        }];

    }

    return self;
}

- (void)setupOnboardingStateMachine {

    TBSMState *wouldYouLikeToChatAlert = [TBSMState stateWithName:CMOnboardingState.WouldYouLikeToChatAlert];
    TBSMState *tapAndHoldToRecordCamment = [TBSMState stateWithName:CMOnboardingState.TapAndHoldToRecordCamment];
    TBSMState *swipeLeftToHideCamments = [TBSMState stateWithName:CMOnboardingState.SwipeLeftToHideCamments];
    TBSMState *swipeRightToShowCamments = [TBSMState stateWithName:CMOnboardingState.SwipeRightToShowCamments];
    TBSMState *pullRightToInviteFriends = [TBSMState stateWithName:CMOnboardingState.PullRightToInviteFriends];
    TBSMState *tapAndHoldToDeleteCamment = [TBSMState stateWithName:CMOnboardingState.TapAndHoldToDeleteCamment];
    TBSMState *tapToPlayCamment = [TBSMState stateWithName:CMOnboardingState.TapToPlayCamment];
    TBSMState *postponedReminder = [TBSMState stateWithName:CMOnboardingState.PostponedReminder];
    TBSMState *skippedReminder = [TBSMState stateWithName:CMOnboardingState.SkippedReminder];
    TBSMState *onboardingFinished = [TBSMState stateWithName:CMOnboardingState.Finished];

    [@[
            tapAndHoldToRecordCamment,
            swipeLeftToHideCamments,
            swipeRightToShowCamments,
            pullRightToInviteFriends,
            tapAndHoldToDeleteCamment,
            tapToPlayCamment,
    ] map:^TBSMState *(TBSMState *state) {

        [state addHandlerForEvent:CMOnboardingEvent.OnboardingSkipped
                           target:skippedReminder];

        return state;
    }];

    __weak typeof(self) __weakSelf = self;
    [skippedReminder setEnterBlock:^(id data) {
        typeof(__weakSelf) _self = __weakSelf;
        [[CMStore instance] setIsOnboardingSkipped:YES];
        [_self.output updateContinueTutorialButtonState];
        [_self.output hideSkipTutorialButton:NO];
        [_self.output showOnboardingAlert:CMOnboardingAlertSkippedOnboardingReminder];
    }];

    [wouldYouLikeToChatAlert addHandlerForEvent:CMOnboardingEvent.OnboardingPostponed
                                         target:postponedReminder
                                           kind:TBSMTransitionExternal
                                         action:^(id data) {
                                             [__weakSelf.output showOnboardingAlert:CMOnboardingAlertPostponedOnboardingReminder];
                                         }];

    [postponedReminder addHandlerForEvent:CMOnboardingEvent.Started target:tapAndHoldToRecordCamment];
    [skippedReminder addHandlerForEvent:CMOnboardingEvent.Started target:tapAndHoldToRecordCamment];
    [wouldYouLikeToChatAlert addHandlerForEvent:CMOnboardingEvent.Started target:tapAndHoldToRecordCamment];

    [tapAndHoldToRecordCamment setEnterBlock:^(id data) {
        typeof(__weakSelf) _self = __weakSelf;
        [[CMStore instance] setIsOnboardingSkipped:NO];
        [_self.output setDisableHiddingCammentBlock:YES];
        [_self.output updateContinueTutorialButtonState];
        [_self.output closeSidebarIfOpened:^{
            typeof(__weakSelf) _self = __weakSelf;
            [_self.output showOnboardingAlert:CMOnboardingAlertTapAndHoldToRecordTooltip];
            [_self.output showSkipTutorialButton];
        }];
    }];

    [tapAndHoldToRecordCamment setExitBlock:^(id data) {
        [__weakSelf.output setDisableHiddingCammentBlock:NO];
    }];

    [tapAndHoldToRecordCamment addHandlerForEvent:CMOnboardingEvent.CammentRecorded
                                         target:tapToPlayCamment
                                           kind:TBSMTransitionExternal
                                         action:^(id data) {
                                             [__weakSelf.output showOnboardingAlert:CMOnboardingAlertTapToPlayCamment];
                                         }];

    [tapToPlayCamment addHandlerForEvent:CMOnboardingEvent.CammentPlayed
                                           target:swipeLeftToHideCamments
                                             kind:TBSMTransitionExternal
                                           action:^(id data) {
                                               [__weakSelf.output showOnboardingAlert:CMOnboardingAlertSwipeLeftToHideCammentsTooltip];
                                           }];
    [tapToPlayCamment setEnterBlock:^(id data) {
        [__weakSelf.output setDisableHiddingCammentBlock:YES];
    }];

    [tapToPlayCamment setExitBlock:^(id data) {
        [__weakSelf.output setDisableHiddingCammentBlock:NO];
    }];

    [swipeLeftToHideCamments addHandlerForEvent:CMOnboardingEvent.CammentBlockSwipedLeft
                                  target:swipeRightToShowCamments
                                    kind:TBSMTransitionExternal
                                  action:^(id data) {
                                      [__weakSelf.output showOnboardingAlert:CMOnboardingAlertSwipeRightToShowCammentsTooltip];
                                  }];

    [swipeRightToShowCamments addHandlerForEvent:CMOnboardingEvent.CammentBlockSwipedRight
                                         target:tapAndHoldToDeleteCamment
                                           kind:TBSMTransitionExternal
                                         action:^(id data) {
                                             [__weakSelf.output showOnboardingAlert:CMOnboardingAlertTapAndHoldToDeleteCammentsTooltip];
                                         }];

    [tapAndHoldToDeleteCamment addHandlerForEvent:CMOnboardingEvent.CammentDeleted
                                  target:pullRightToInviteFriends
                                    kind:TBSMTransitionExternal
                                  action:^(id data) {
                                      [__weakSelf.output showOnboardingAlert:CMOnboardingAlertPullRightToInviteFriendsTooltip];
                                  }];

    [tapAndHoldToDeleteCamment setEnterBlock:^(id data) {
        [__weakSelf.output setDisableHiddingCammentBlock:YES];
    }];

    [tapAndHoldToDeleteCamment setExitBlock:^(id data) {
        [__weakSelf.output setDisableHiddingCammentBlock:NO];
    }];

    [pullRightToInviteFriends addHandlerForEvent:CMOnboardingEvent.GroupInfoSidebarOpened
                                           target:onboardingFinished
                                             kind:TBSMTransitionExternal
                                           action:^(id data) {
                                               [__weakSelf.output hideOnboardingAlert:CMOnboardingAlertPullRightToInviteFriendsTooltip];
                                               [__weakSelf.output hideSkipTutorialButton: YES];
                                               [CMStore instance].isOnboardingFinished = YES;
                                           }];

    [pullRightToInviteFriends setEnterBlock:^(id data) {
        [__weakSelf.output setDisableHiddingCammentBlock:YES];
    }];

    [pullRightToInviteFriends setExitBlock:^(id data) {
        [__weakSelf.output setDisableHiddingCammentBlock:NO];
    }];

    self.onboardingStateMachine = [TBSMStateMachine stateMachineWithName:@"Onboarding"];
    self.onboardingStateMachine.states = @[
            wouldYouLikeToChatAlert,
            tapAndHoldToRecordCamment,
            swipeLeftToHideCamments,
            swipeRightToShowCamments,
            pullRightToInviteFriends,
            tapAndHoldToDeleteCamment,
            tapToPlayCamment,
            postponedReminder,
            skippedReminder,
            onboardingFinished
    ];
    self.onboardingStateMachine.initialState = wouldYouLikeToChatAlert;
    [self.onboardingStateMachine setUp:nil];
}

- (void)setupView {
    [self.output setCammentsBlockNodeDelegate:_cammentsBlockNodePresenter];
    [self updateChatWithActiveGroup];
}

- (void)checkIfNeedForOnboarding {
    if (![CMStore instance].isOnboardingFinished
            && !self.onboardingWasStarted
            && ![CMStore instance].isOnboardingSkipped
            && [CMStore instance].activeGroup == nil) {
        [self.output askForSetupPermissions];
    } else if (!self.isCameraSessionConfigured) {
        [self setupCameraSession];
    }
}

- (void)setupCameraSession {
    [self.recorderInteractor configureCamera];
    [self.output presenterDidRequestViewPreviewView];
    self.isCameraSessionConfigured = YES;
}


- (void)readyToShowOnboarding {
    self.onboardingWasStarted = YES;
    [self runOnboarding];
}

- (void)runOnboarding {
    [self sendOnboardingEvent:CMOnboardingEvent.Started];
    [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventOnboardingStart];
}

- (void)updateCammentsAfterConnectionHasRestored {
    [self.loaderInteractor resetPaginationKey];
    [self.loaderInteractor loadNextPageOfCamments:[CMStore instance].activeGroup.uuid];

    NSArray *cammentsToUpload = [[self.cammentsBlockNodePresenter.items.rac_sequence filter:^BOOL(CMCammentsBlockItem *item) {
        __block BOOL shouldUpload = NO;
        [item matchCamment:^(CMCamment *camment) {
            shouldUpload = camment.status.deliveryStatus == CMCammentDeliveryStatusNotSent;
        } botCamment:^(CMBotCamment *botCamment) {

        }];
        return shouldUpload;
    }] map:^id(CMCammentsBlockItem *item) {
        __block  CMCamment *resultCamment = nil;
        [item matchCamment:^(CMCamment *camment) {
                    resultCamment = camment;
                }
                botCamment:^(CMBotCamment *botCamment) {

                }];
        return resultCamment;
    }].array;

    for (CMCamment *item in cammentsToUpload) {
        [self.interactor uploadCamment:item];
    }
}

- (void)updateChatWithActiveGroup {
    [self.cammentsBlockNodePresenter reloadItems:@[] animated:YES];
    [self.loaderInteractor resetPaginationKey];
    [self.loaderInteractor loadNextPageOfCamments:[CMStore instance].activeGroup.uuid];
    [self setupPresentationInstruction];
}

- (void)updateCameraOrientation:(AVCaptureVideoOrientation)orientation {
    [self.recorderInteractor updateDeviceOrientation:orientation];
}

- (UIInterfaceOrientationMask)contentPossibleOrientationMask {
    return UIInterfaceOrientationMaskAll;
}

- (void)setupPresentationInstruction {
#ifdef INTERNALSDK
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
    @weakify(self);
    [[[builder bots].rac_sequence map:^id(id <CMBot> bot) {
        @strongify(self);
        [self.botRegistry addBot:bot];
        return nil;
    }] array];
#endif
}


- (void)didFetchCamments:(NSArray<CMCamment *> *)camments canLoadMore:(BOOL)canLoadMore firstPage:(BOOL)isFirstPage {
    self.canLoadMoreCamments = canLoadMore;
    NSArray<CMCammentsBlockItem *> *items = [camments.rac_sequence map:^id(CMCamment *value) {
        return [CMCammentsBlockItem cammentWithCamment:value];
    }].array;
    [self.cammentsBlockNodePresenter updateItems:items animated:YES];
    if (self.cammentBatchContext) {
        [self.cammentBatchContext completeBatchFetching:YES];
    }
}

- (void)playCamment:(NSString *)cammentId {
    [_cammentsBlockNodePresenter playCamment:cammentId];
}

- (void)connectPreviewViewToRecorder:(SCImageView *)view {
    [_recorderInteractor connectPreviewViewToRecorder:view];
}

- (void)recorderNoticedDeniedCameraOrMicrophonePermission {
    [CMStore instance].cammentRecordingState = CMCammentRecordingStateCancelled;
    [self.output showAllowCameraPermissionsView];
}

- (void)recorderDidFinishAVAsset:(AVAsset *)asset uuid:(NSString *)uuid {
    if (asset) {
        if (CMTimeGetSeconds(asset.duration) < 0.5) {return;}
        NSString *groupUUID = [[CMStore instance].activeGroup uuid];
        CMCammentBuilder *cammentBuilder = [CMCammentBuilder new];
        CMCamment *camment = [[[[[[[cammentBuilder withUuid:uuid]
                withShowUuid:[CMStore instance].currentShowMetadata.uuid]
                withUserGroupUuid:groupUUID]
                withUserCognitoIdentityId:self.userSessionController.user.cognitoUserId]
                withLocalAsset:asset]
                withStatus:[[CMCammentStatus alloc] initWithDeliveryStatus:CMCammentDeliveryStatusNotSent
                                                                 isWatched:YES]]
                build];
        @weakify(self);
        [self.cammentsBlockNodePresenter insertNewItem:[CMCammentsBlockItem cammentWithCamment:camment]
                                            completion:^{
                                                @strongify(self);
                                                if (!self) { return; }
                                                [self sendOnboardingEvent:CMOnboardingEvent.CammentRecorded];
                                            }];
    }
}

- (void)recorderDidFinishExportingToURL:(NSURL *)url uuid:(NSString *)uuid {

    if ([CMStore instance].isOfflineMode) {
        return;
    }

    AVAsset *asset = [AVAsset assetWithURL:url];
    if (!asset || (CMTimeGetSeconds(asset.duration) < 0.5)) {return;}

    CMCamment *cammentToUpload = [[[[[[[CMCammentBuilder new] withUuid:uuid]
            withLocalURL:url.absoluteString]
            withShowUuid:[CMStore instance].currentShowMetadata.uuid]
            withUserGroupUuid:[CMStore instance].activeGroup ? [CMStore instance].activeGroup.uuid : nil]
            withUserCognitoIdentityId:self.userSessionController.user.cognitoUserId]
            build];
    [self.cammentsBlockNodePresenter updateCammentData:cammentToUpload];
    [self.interactor uploadCamment:cammentToUpload];
}

- (void)interactorDidUploadCamment:(CMCamment *)uploadedCamment {
    [self.cammentsBlockNodePresenter updateCammentData:uploadedCamment];
}

- (void)interactorFailedToUploadCamment:(CMCamment *)camment error:(NSError *)error {
    DDLogError(@"Failed to upload camment %@ with error %@", camment, error);
    [[CMErrorWireframe new] presentErrorViewWithError:error
                                     inViewController:(id) self.output];
}

- (void)checkIfCammentShouldBeDeleted:(CMCamment *)camment {
    NSArray *deletedCamments = [self.cammentsBlockNodePresenter.deletedCamments.rac_sequence
            filter:^BOOL(CMCamment *deletedCamment) {
                return [deletedCamment.uuid isEqualToString:camment.uuid]
                        && !deletedCamment.isDeleted;
            }].array ?: @[];

    for (CMCamment *cammentToDelete in deletedCamments) {
        DDLogVerbose(@"Run postponed camment deletion on uuid %@", cammentToDelete.uuid);
        [self.interactor deleteCament:cammentToDelete];
    }
}

- (void)interactorDidDeleteCamment:(CMCamment *)camment {
    self.cammentsBlockNodePresenter.deletedCamments = [self.cammentsBlockNodePresenter.deletedCamments.rac_sequence map:^id(CMCamment *value) {
        if ([value.uuid isEqualToString:camment.uuid]) {
            DDLogVerbose(@"Camment has been deleted %@", value.uuid);
            CMCammentBuilder *builder = [[CMCammentBuilder cammentFromExistingCamment:value] withIsDeleted:YES];
            return [builder build];
        }
        return value;
    }].array;
}

- (BOOL)isCammentMarkedAsDeleted:(CMCamment *)camment {
    NSArray *deletedCamments = [self.cammentsBlockNodePresenter.deletedCamments.rac_sequence
            filter:^BOOL(CMCamment *deletedCamment) {
                return [deletedCamment.uuid isEqualToString:camment.uuid];
            }].array ?: @[];
    return deletedCamments.count > 0;
}

- (void)didReceiveNewCamment:(CMCamment *)camment {

    if ([self isCammentMarkedAsDeleted:camment]) {
        DDLogVerbose(@"Camment has been marked as deleted %@", camment.uuid);
        [self checkIfCammentShouldBeDeleted:camment];
        return;
    }

    NSArray *filteredItemsArray = [self.cammentsBlockNodePresenter.items.rac_sequence filter:^BOOL(CMCammentsBlockItem *value) {
        __block BOOL result = NO;

        [value matchCamment:^(CMCamment *mathedCamment) {
            result = [camment.uuid isEqualToString:mathedCamment.uuid];
        }        botCamment:^(CMBotCamment *ads) {
        }];

        return result;
    }].array ?: @[];

    BOOL isNewItem = filteredItemsArray.count == 0;

    if ([camment.userGroupUuid isEqualToString:[[CMStore instance].activeGroup uuid]]
            || [camment.showUuid isEqualToString:kCMPresentationBuilderUtilityAnyShowUUID]) {
        if (isNewItem) {
            [self.cammentsBlockNodePresenter insertNewItem:[CMCammentsBlockItem cammentWithCamment:camment] completion:^{
            }];
        } else {
            [self.cammentsBlockNodePresenter updateCammentData:camment];
        }
    }
}

- (void)didReceiveNewBotCamment:(CMBotCamment *)botCamment {
    [self.cammentsBlockNodePresenter
            insertNewItem:[CMCammentsBlockItem botCammentWithBotCamment:botCamment]
               completion:^{
               }];
}

- (void)didReceiveDeliveryConfirmation:(NSString *)cammentUuid {
    __block CMCamment *cammentToUpdate = nil;
    for (CMCammentsBlockItem *item in self.cammentsBlockNodePresenter.items) {
        [item matchCamment:^(CMCamment *camment) {
                    if ([camment.uuid isEqualToString:cammentUuid]) {
                        cammentToUpdate = camment;
                    }
                }
                botCamment:^(CMBotCamment *botCamment) {
                }];
        if (cammentToUpdate) {break;}
    }

    if (!cammentToUpdate) {return;}

    CMCammentStatus *status = [[CMCammentStatus alloc] initWithDeliveryStatus:CMCammentDeliveryStatusDelivered
                                                                    isWatched:cammentToUpdate.status.isWatched];
    cammentToUpdate = [[[CMCammentBuilder cammentFromExistingCamment:cammentToUpdate]
            withStatus:status]
            build];
    [self.cammentsBlockNodePresenter updateCammentData:cammentToUpdate];
}


- (void)inviteFriendsAction {
    [self sendOnboardingEvent:CMOnboardingEvent.GroupInfoSidebarOpened];

    if (self.userSessionController.userAuthentificationState == CMCammentUserAuthentificatedAsKnownUser) {
        [self getInvitationDeeplink];
    } else {
        [self.output showLoadingHUD];
        [[self.userSessionController refreshSession:YES]
                continueWithExecutor:[AWSExecutor mainThreadExecutor]
                           withBlock:^id(AWSTask<CMAuthStatusChangedEventContext *> *task) {
                               if (task.error || task.result.state != CMCammentUserAuthentificatedAsKnownUser) {
                                   [self.output hideLoadingHUD];
                               } else {
                                   [self inviteFriendsAction];
                                   [self.output hideLoadingHUD];
                               }
                               return nil;
                           }];
    }
    [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventInvite];
}

- (void)getInvitationDeeplink {
    [self.output showLoadingHUD];
    [self.invitationInteractor getDeeplink:[CMStore instance].activeGroup showUuid:[CMStore instance].currentShowMetadata.uuid];
}

- (void)sendOnboardingEvent:(NSString *)event {
    [self.onboardingStateMachine scheduleEvent:[TBSMEvent eventWithName:event
                                                                   data:nil]];
}

- (void)presentCammentOptionsDialog:(CMCammentCell *)cammentCell {

    if ([CMStore instance].cammentRecordingState == CMCammentRecordingStateRecording) {
        return;
    }

    if ([self.onboardingStateMachine.currentState.name isEqualToString:CMOnboardingState.TapToPlayCamment]) {
        return;
    }

    if (!([CMStore instance].isOnboardingFinished || [CMStore instance].isOnboardingSkipped)
        && self.onboardingWasStarted
        && ![self.onboardingStateMachine.currentState.name isEqualToString:CMOnboardingState.TapAndHoldToDeleteCamment]) {
        return;
    }
    
    CMCammentActionsMask actions = CMCammentActionsMaskNone;
    if (([cammentCell.displayingContext.camment.userCognitoIdentityId isEqualToString:self.userSessionController.user.cognitoUserId])
            || (self.userSessionController.user.cognitoUserId == nil && cammentCell.displayingContext.camment.userCognitoIdentityId == nil))
    {
        actions = actions | CMCammentActionsMaskDelete;
    }
    [self.output presentCammentOptionsView:cammentCell actions:actions];
}

- (void)deleteCammentAction:(CMCamment *)camment {
    CMCammentsBlockItem *cammentsBlockItem = [CMCammentsBlockItem cammentWithCamment:camment];
    if ([[CMStore instance].playingCammentId isEqualToString:camment.uuid]) {
        [CMStore instance].playingCammentId = kCMStoreCammentIdIfNotPlaying;
    }

    [self.cammentsBlockNodePresenter deleteItem:cammentsBlockItem];
    [self.interactor deleteCament:camment];
    [self sendOnboardingEvent:CMOnboardingEvent.CammentDeleted];
    [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventCammentDelete];
}

- (void)didReceiveCammentDeletedMessage:(CMCammentDeletedMessage *)message {
    CMCammentsBlockItem *cammentsBlockItem = [CMCammentsBlockItem cammentWithCamment:message.camment];
    [self.cammentsBlockNodePresenter deleteItem:cammentsBlockItem];
}

- (void)presentationInstruction:(id <CMPresentationInstructionInterface>)instruction presentsViewController:(UIViewController *)viewController {
    [self.output presentViewController:viewController];
}

- (void)didInviteUsersToTheGroup:(CMUsersGroup *)group usingDeeplink:(BOOL)usedDeeplink {
    [self.output hideLoadingHUD];
    if (usedDeeplink) {
        [self showShareDeeplinkDialog:group.invitationLink];
    }

    [[CMStore instance] setActiveGroup:group];
}

- (void)didFailToInviteUsersWithError:(NSError *)error {
    [self.output hideLoadingHUD];
    [[CMErrorWireframe new] presentErrorViewWithError:error
                                     inViewController:(id) self.output];
}

- (void)didFailToGetInvitationLink:(NSError *)error {
    [self.output hideLoadingHUD];
    [[CMErrorWireframe new] presentErrorViewWithError:error
                                     inViewController:(id) self.output];
}


- (void)runBotCammentAction:(CMBotAction *)action {
    [self.botRegistry runAction:action];
}

- (void)showShareDeeplinkDialog:(NSString *)link {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:CMLocalized(@"Send the invitation link")]
                                                                             message:CMLocalized(@"Invite users by sharing the invitation link via channel of your choice")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *textToShare = [CMStore instance].currentShowMetadata.invitationText;
        NSURL *url = [NSURL URLWithString:link];

        NSString *shareString = [NSString stringWithFormat:@"%@ %@", textToShare, url.absoluteString];
        NSArray *objectsToShare = @[shareString];

        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare
                                                                                 applicationActivities:nil];

        activityVC.popoverPresentationController.sourceView = self.wireframe.parentViewController.view;
        [self.wireframe.parentViewController presentViewController:activityVC
                                                          animated:YES
                                                        completion:nil];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"cancel")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                      }]];

    [self.wireframe.parentViewController presentViewController:alertController
                                                      animated:YES
                                                    completion:nil];
}

- (void)presentationInstruction:(id <CMPresentationInstructionInterface>)instruction
                   playVideoAds:(CMVideoAd *)videoAd
           playStartingFromRect:(CGRect)rect {
    [self.output playAdVideo:videoAd startingFromRect:rect];
}

- (void)didFailToLoadCamments:(NSError *)error {
    if (self.cammentBatchContext) {
        [self.cammentBatchContext completeBatchFetching:YES];
    }

    [[CMErrorWireframe new] presentErrorViewWithError:error
                                     inViewController:(id) self.output];
}

- (BOOL)loaderCanLoadMoreCamments {
    return NO;//self.canLoadMoreCamments;
}

- (void)fetchNextPageOfCamments:(ASBatchContext *)context {
    self.cammentBatchContext = context;
}

@end
