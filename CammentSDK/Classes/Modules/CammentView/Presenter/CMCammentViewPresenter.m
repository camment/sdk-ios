//
//  CMCammentViewCMCammentViewPresenter.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "FBSDKAccessToken.h"
#import <DateTools/DateTools.h>
#import "CMCammentViewPresenter.h"
#import "CMCammentViewWireframe.h"
#import "CMInvitationWireframe.h"
#import "CMPresentationInstructionOutput.h"
#import "CMPresentationPlayerInteractor.h"
#import "CMCammentsBlockPresenter.h"
#import "CMShow.h"
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
#import "CMAPICammentInRequest.h"
#import "CMAPIDevcammentClient.h"
#import "CMAuthInteractor.h"
#import "CammentSDK.h"
#import "CMCammentBuilder.h"
#import "CMShowMetadata.h"
#import "CMUserJoinedMessage.h"
#import "CMCammentDeletedMessage.h"
#import "RACSignal+SignalHelpers.h"
#import "CMCammentCell.h"
#import "CMBotRegistry.h"

@interface CMCammentViewPresenter () <CMPresentationInstructionOutput, CMAuthInteractorOutput, CMCammentsBlockPresenterOutput, CMInvitationInteractorOutput>

@property(nonatomic, strong) CMPresentationPlayerInteractor *presentationPlayerInteractor;
@property(nonatomic, strong) CMAuthInteractor *authInteractor;
@property(nonatomic, strong) CMInvitationInteractor *invitationInteractor;
@property(nonatomic, strong) CMCammentsBlockPresenter *cammentsBlockNodePresenter;
@property(nonatomic, strong) CMShowMetadata *show;
@property(nonatomic, strong) CMUsersGroup *usersGroup;
@property(nonatomic, weak) RACDisposable *willStartRecordSignal;

@property(nonatomic, assign) BOOL isOnboardingRunning;
@property(nonatomic, assign) CMOnboardingAlertMaskType completedOnboardingSteps;
@property(nonatomic, assign) CMOnboardingAlertType currentOnboardingStep;

@property(nonatomic) BOOL isCameraSessionConfigured;
@property(nonatomic) BOOL onboardingWasStarted;

@property(nonatomic) CMBotRegistry *botRegistry;
@end

@implementation CMCammentViewPresenter

- (instancetype)initWithShowMetadata:(CMShowMetadata *)metadata {
    self = [super init];

    if (self) {
        self.show = metadata;
        self.cammentsBlockNodePresenter = [CMCammentsBlockPresenter new];
        self.cammentsBlockNodePresenter.output = self;
        self.presentationPlayerInteractor = [CMPresentationPlayerInteractor new];

        self.authInteractor = [CMAuthInteractor new];
        self.authInteractor.output = self;

        self.invitationInteractor = [CMInvitationInteractor new];
        self.invitationInteractor.output = self;

        self.presentationPlayerInteractor.instructionOutput = self;
        self.usersGroup = [CMStore instance].activeGroup;
        self.completedOnboardingSteps = CMOnboardingAlertMaskNone;
        self.currentOnboardingStep = CMOnboardingAlertNone;

        self.botRegistry = [CMBotRegistry new];
        [self.botRegistry updateBotsOutputInterface:self];

        @weakify(self);
        [[RACObserve([CMStore instance], activeGroup) deliverOnMainThread] subscribeNext:^(CMUsersGroup *group) {
            @strongify(self);
            self.usersGroup = group;
        }];

        [[[[CMStore instance] reloadActiveGroupSubject] deliverOnMainThread] subscribeNext:^(NSNumber *shouldReload) {
            @strongify(self);
            if (shouldReload.boolValue) {
                [self updateChatWithActiveGroup];
            }
        }];

        [RACObserve([CMStore instance], playingCammentId) subscribeNext:^(NSString *nextId) {
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
                [self.willStartRecordSignal dispose];
                [[CMStore instance] setPlayingCammentId:kCMStoreCammentIdIfNotPlaying];
                [self.recorderInteractor cancelRecording];
                return [RACSignal empty];
            }

            return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
                [subscriber sendNext:@YES];
                return nil;
            }];
        }] subscribeNext:^(id x) {
            if (!self.isCameraSessionConfigured) {
                [self.output askForSetupPermissions];
                return;
            }
            [[CMStore instance] setPlayingCammentId:kCMStoreCammentIdIfNotPlaying];
            self.willStartRecordSignal = [[[[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
                [subscriber sendCompleted];
                return nil;
            }] delay:0.5] deliverOnMainThread] subscribeCompleted:^{
                [self.recorderInteractor startRecording];
            }];
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
}

- (void)updateChatWithActiveGroup {
    [self.cammentsBlockNodePresenter reloadItems:@[] animated:YES];
    [self.loaderInteractor fetchCachedCamments:self.usersGroup.uuid];
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

- (void)recorderDidFinishAVAsset:(AVAsset *)asset uuid:(NSString *)uuid {
    if (asset) {
        if (CMTimeGetSeconds(asset.duration) < 0.5) {return;}
        NSString *groupUUID = [self.usersGroup uuid];
        CMCammentBuilder *cammentBuilder = [CMCammentBuilder new];
        CMCamment *camment = [[[[[[cammentBuilder withUuid:uuid]
                withShowUuid:self.show.uuid]
                withUserGroupUuid:groupUUID]
                withUserCognitoIdentityId:[CMStore instance].cognitoUserId]
                withLocalAsset:asset] build];
        [self.cammentsBlockNodePresenter insertNewItem:[CMCammentsBlockItem cammentWithCamment:camment]
                                            completion:^{
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
            withShowUuid:self.show.uuid]
            withUserGroupUuid:self.usersGroup ? self.usersGroup.uuid : nil]
            withUserCognitoIdentityId:[CMStore instance].cognitoUserId]
            build];
    [self.interactor uploadCamment:cammentToUpload];
}

- (void)interactorDidUploadCamment:(CMCamment *)uploadedCamment {
    NSMutableArray<CMCammentsBlockItem *> *mutableCamments = (NSMutableArray *) [self.cammentsBlockNodePresenter.items mutableCopy];
    NSInteger index = [self.cammentsBlockNodePresenter.items indexOfObjectPassingTest:^BOOL(CMCammentsBlockItem *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        __block BOOL result = NO;

        [obj matchCamment:^(CMCamment *camment) {
            result = [camment.uuid isEqualToString:uploadedCamment.uuid];
        }             botCamment:^(CMBotCamment *ads) {
        }];

        return result;
    }];

    if (index != NSNotFound) {
        CMCammentsBlockItem *cammentsBlockItem = mutableCamments[(NSUInteger) index];
        [cammentsBlockItem matchCamment:^(CMCamment *camment) {
            mutableCamments[(NSUInteger) index] = [CMCammentsBlockItem cammentWithCamment:uploadedCamment];
        }                           botCamment:^(CMBotCamment *ads) {
        }];
    }
    self.cammentsBlockNodePresenter.items = mutableCamments.copy;
}

- (void)interactorFailedToUploadCamment:(CMCamment *)camment error:(NSError *)error {
    DDLogError(@"Failed to upload camment %@ with error %@", camment, error);
}


- (void)didReceiveNewCamment:(CMCamment *)camment {

    NSArray *filteredItemsArray = [self.cammentsBlockNodePresenter.items.rac_sequence filter:^BOOL(CMCammentsBlockItem *value) {
        __block BOOL result = NO;

        [value matchCamment:^(CMCamment *mathedCamment) {
            result = [camment.uuid isEqualToString:mathedCamment.uuid];
        }               botCamment:^(CMBotCamment *ads) {
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
        [self.cammentsBlockNodePresenter insertNewItem:[CMCammentsBlockItem cammentWithCamment:camment] completion:^{
        }];
    }
}

- (void)didReceiveNewBotCamment:(CMBotCamment *)botCamment {
    [self.cammentsBlockNodePresenter
            insertNewItem:[CMCammentsBlockItem botCammentWithBotCamment:botCamment]
               completion:^{}];
}

- (void)inviteFriendsAction {
    [self completeActionForOnboardingAlert:CMOnboardingAlertSwipeDownToInviteFriendsTooltip];
    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    [CMStore instance].isFBConnected = token != nil && [token.expirationDate laterDate:[NSDate date]];
    if ([CMStore instance].isFBConnected) {
        [self getInvitationDeeplink];
    } else {
        [self.output showLoadingHUD];
        [_authInteractor signInWithFacebookProvider:(id) self.output];
    }
}

- (void)getInvitationDeeplink {
    [self.output showLoadingHUD];
    [self.invitationInteractor getDeeplink:[CMStore instance].activeGroup showUuid:self.show.uuid];
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
    if ([cammentCell.camment.userCognitoIdentityId isEqualToString:[CMStore instance].cognitoUserId]
        || [CMStore instance].cognitoUserId == nil && cammentCell.camment.userCognitoIdentityId == nil ) {
        [self completeActionForOnboardingAlert:CMOnboardingAlertTapAndHoldToDeleteCammentsTooltip];
        actions = actions | CMCammentActionsMaskDelete;
    }
    [self.output presentCammentOptionsView:cammentCell actions:actions];
}

- (void)deleteCammentAction:(CMCamment *)camment {
    CMCammentsBlockItem *cammentsBlockItem = [CMCammentsBlockItem cammentWithCamment:camment];
    [self.cammentsBlockNodePresenter deleteItem:cammentsBlockItem];
    [self.interactor deleteCament:camment];
}

- (void)didReceiveUserJoinedMessage:(CMUserJoinedMessage *)message {
    if ([message.userGroupUuid isEqualToString:[CMStore instance].activeGroup.uuid] &&
            ![message.joinedUser.cognitoUserId isEqualToString:[CMStore instance].cognitoUserId]) {
        [self.output presentUserJoinedMessage:message];
    }
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
}

- (void)didFailToInviteUsersWithError:(NSError *)error {

}

- (void)didFailToGetInvitationLink:(NSError *)error {
    [self.output hideLoadingHUD];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:CMLocalized(@"Ooops")]
                                                                             message:CMLocalized(@"Couldn't get the invitation link. Check your internet connection and try again.")
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }]];

    [self.wireframe.parentViewController presentViewController:alertController
                                                      animated:YES
                                                    completion:nil];
}


- (void)runBotCammentAction:(CMBotAction *)action {
    [self.botRegistry runAction:action];
}

- (void)showShareDeeplinkDialog:(NSString *)link {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:CMLocalized(@"Send the invitation link")]
                                                                             message:CMLocalized(@"Invite users by sharing the invitation link via channel of your choice")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *textToShare = @"Hey, join our private chat!";
        NSURL *url = [NSURL URLWithString:link];

        NSArray *objectsToShare = @[textToShare, url];

        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];

        activityVC.popoverPresentationController.sourceView = self.wireframe.parentViewController.view;
        [self.wireframe.parentViewController presentViewController:activityVC
                                                          animated:YES
                                                        completion:nil];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }]];

    [self.wireframe.parentViewController presentViewController:alertController
                                                      animated:YES
                                                    completion:nil];
}

@end
