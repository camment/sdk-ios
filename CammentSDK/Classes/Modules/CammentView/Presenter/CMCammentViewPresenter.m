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

@interface CMCammentViewPresenter () <CMPresentationInstructionOutput>

@property(nonatomic, strong) CMPresentationPlayerInteractor *presentationPlayerInteractor;
@property(nonatomic, strong) id <CMInvitationInteractorInput> invitationInteractor;
@property(nonatomic, strong) id <CMCammentsBlockPresenterInput> cammentsBlockNodePresenter;
@property(nonatomic, weak) RACDisposable *willStartRecordSignal;

@property(nonatomic, assign) BOOL isOnboardingRunning;
@property(nonatomic, assign) CMOnboardingAlertMaskType completedOnboardingSteps;
@property(nonatomic, assign) CMOnboardingAlertType currentOnboardingStep;

@property(nonatomic) BOOL isCameraSessionConfigured;
@property(nonatomic) BOOL onboardingWasStarted;

@property(nonatomic) CMBotRegistry *botRegistry;
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
        self.completedOnboardingSteps = CMOnboardingAlertMaskNone;
        self.currentOnboardingStep = CMOnboardingAlertNone;

        self.botRegistry = [CMBotRegistry new];
        [self.botRegistry updateBotsOutputInterface:self];

        @weakify(self);
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

        [[[RACObserve([CMStore instance], playingCammentId)
                takeUntil:self.rac_willDeallocSignal]
                deliverOnMainThread]
                subscribeNext:^(NSString *nextId) {
                    @strongify(self);
                    [self playCamment:nextId];
                    if (self.isOnboardingRunning) {
                        if ([nextId isEqualToString:kCMStoreCammentIdIfNotPlaying]) {
                            [self completeActionForOnboardingAlert:CMOnboardingAlertTapToPlayCamment];
                        } else {
                            [self.output hideOnboardingAlert:CMOnboardingAlertTapToPlayCamment];
                        }

                        if (self.currentOnboardingStep == CMOnboardingAlertSwipeLeftToHideCammentsTooltip) {
                            [self showOnboardingAlert:CMOnboardingAlertSwipeLeftToHideCammentsTooltip];
                        }
                    }
                }];

        __weak typeof(self) weakSelf = self;
        [[[[RACObserve([CMStore instance], cammentRecordingState) takeUntil:weakSelf.rac_willDeallocSignal]
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

        [[[RACSignal combineLatest:@[
                RACObserve(self.cammentsBlockNodePresenter, items),
                RACObserve([CMStore instance], currentShowTimeInterval)
        ]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(RACTuple *tuple) {
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

    }

    return self;
}

- (void)setupView {
    [self.output setCammentsBlockNodeDelegate:_cammentsBlockNodePresenter];
    [self updateChatWithActiveGroup];
}

- (CMOnboardingAlertType)currentOnboardingStep {
    return _currentOnboardingStep;
}

- (void)checkIfNeedForOnboarding {
    if (![CMStore instance].isOnboardingFinished && !self.onboardingWasStarted) {
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
    _isOnboardingRunning = YES;
    [self showOnboardingAlert:CMOnboardingAlertTapAndHoldToRecordTooltip];
    [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventOnboardingStart];
}

- (void)updateChatWithActiveGroup {
    [self.cammentsBlockNodePresenter reloadItems:@[] animated:YES];
    [self.loaderInteractor fetchCachedCamments:[CMStore instance].activeGroup.uuid];
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


- (void)didFetchCamments:(NSArray<CMCamment *> *)camments {
    NSArray<CMCamment *> *items = [camments.rac_sequence map:^id(CMCamment *value) {
        return [CMCammentsBlockItem cammentWithCamment:value];
    }].array;
    [self.cammentsBlockNodePresenter reloadItems:items animated:YES];
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
                                                if (!self) {return;}
                                                if (self.isOnboardingRunning) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [self completeActionForOnboardingAlert:CMOnboardingAlertTapAndHoldToRecordTooltip];
                                                    });
                                                }
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
                botCamment:^(CMBotCamment *botCamment) {}];
        if (cammentToUpdate) { break; }
    }

    if (!cammentToUpdate) { return; }

    CMCammentStatus *status = [[CMCammentStatus alloc] initWithDeliveryStatus:CMCammentDeliveryStatusDelivered
                                                                    isWatched:cammentToUpdate.status.isWatched];
    cammentToUpdate = [[[CMCammentBuilder cammentFromExistingCamment:cammentToUpdate]
            withStatus:status]
            build];
    [self.cammentsBlockNodePresenter updateCammentData:cammentToUpdate];
}


- (void)inviteFriendsAction {
    [self completeActionForOnboardingAlert:CMOnboardingAlertSwipeDownToInviteFriendsTooltip];
    [CMStore instance].isOnboardingFinished = YES;

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

- (void)showOnboardingAlert:(CMOnboardingAlertType)type {

    CMOnboardingAlertMaskType maskType = (CMOnboardingAlertMaskType) (1 << type);
    BOOL shouldDisplayAlert = YES;

    switch (type) {
        case CMOnboardingAlertNone:
            break;
        case CMOnboardingAlertWouldYouLikeToChatAlert:
            break;
        case CMOnboardingAlertWhatIsCammentTooltip:
            break;
        case CMOnboardingAlertTapAndHoldToRecordTooltip:
            break;
        case CMOnboardingAlertSwipeLeftToHideCammentsTooltip:
            shouldDisplayAlert = (self.completedOnboardingSteps & CMOnboardingAlertTapToPlayMaskCamment);
            break;
        case CMOnboardingAlertSwipeRightToShowCammentsTooltip:
            shouldDisplayAlert = (self.completedOnboardingSteps & CMOnboardingAlertSwipeLeftToHideCammentsMaskTooltip);
            break;
        case CMOnboardingAlertSwipeDownToInviteFriendsTooltip:
            break;
        case CMOnboardingAlertTapAndHoldToDeleteCammentsTooltip:
            break;
        case CMOnboardingAlertTapToPlayCamment:
            shouldDisplayAlert = (self.completedOnboardingSteps & CMOnboardingAlertTapAndHoldToRecordMaskTooltip);
            break;
    }

    if (!(self.completedOnboardingSteps & maskType) && shouldDisplayAlert) {
        self.currentOnboardingStep = type;
        [self.output showOnboardingAlert:type];
    }
}

- (void)completeActionForOnboardingAlert:(CMOnboardingAlertType)type {
    if (_currentOnboardingStep != type) {
        return;
    }

    self.completedOnboardingSteps = self.completedOnboardingSteps | (1 << type);
    [self.output hideOnboardingAlert:type];

    switch (type) {
        case CMOnboardingAlertNone:
            break;
        case CMOnboardingAlertWouldYouLikeToChatAlert:
            break;
        case CMOnboardingAlertWhatIsCammentTooltip:
            break;
        case CMOnboardingAlertTapAndHoldToRecordTooltip:
            [self showOnboardingAlert:CMOnboardingAlertTapToPlayCamment];
            break;
        case CMOnboardingAlertSwipeLeftToHideCammentsTooltip:
            [self showOnboardingAlert:CMOnboardingAlertSwipeRightToShowCammentsTooltip];
            break;
        case CMOnboardingAlertSwipeRightToShowCammentsTooltip:
            [self showOnboardingAlert:CMOnboardingAlertTapAndHoldToDeleteCammentsTooltip];
            break;
        case CMOnboardingAlertSwipeDownToInviteFriendsTooltip:
            [CMStore instance].isOnboardingFinished = YES;
            break;
        case CMOnboardingAlertTapAndHoldToDeleteCammentsTooltip:
            [CMStore instance].isOnboardingFinished = YES;
            [self showOnboardingAlert:CMOnboardingAlertSwipeDownToInviteFriendsTooltip];
            break;
        case CMOnboardingAlertTapToPlayCamment:
            [self showOnboardingAlert:CMOnboardingAlertSwipeLeftToHideCammentsTooltip];
            break;
    }
}

- (void)cancelActionForOnboardingAlert:(CMOnboardingAlertType)type {
    if (_currentOnboardingStep != type) {
        return;
    }
}

- (void)presentCammentOptionsDialog:(CMCammentCell *)cammentCell {

    CMCammentActionsMask actions = CMCammentActionsMaskNone;
    if ([cammentCell.displayingContext.camment.userCognitoIdentityId isEqualToString:self.userSessionController.user.cognitoUserId]
            || self.userSessionController.user.cognitoUserId == nil && cammentCell.displayingContext.camment.userCognitoIdentityId == nil) {
        [self completeActionForOnboardingAlert:CMOnboardingAlertTapAndHoldToDeleteCammentsTooltip];
        actions = actions | CMCammentActionsMaskDelete;
    }
    [self.output presentCammentOptionsView:cammentCell actions:actions];
}

- (void)deleteCammentAction:(CMCamment *)camment {
    CMCammentsBlockItem *cammentsBlockItem = [CMCammentsBlockItem cammentWithCamment:camment];
    [self.cammentsBlockNodePresenter deleteItem:cammentsBlockItem];
    [self.interactor deleteCament:camment];
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

        NSArray *objectsToShare = @[textToShare, url];

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

@end
