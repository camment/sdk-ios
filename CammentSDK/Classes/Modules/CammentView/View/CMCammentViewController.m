//
//  CMCammentViewCMCammentViewViewController.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "AMPopTip.h"
#import "CMCammentViewController.h"
#import "CMCammentButton.h"
#import "CMStore.h"
#import "CMCammentsBlockNode.h"
#import "CMCammentRecorderPreviewNode.h"
#import "UIColorMacros.h"
#import "CMCammentRecorderInteractorInput.h"
#import "CMCamment.h"
#import "CMUserJoinedMessage.h"
#import "CMCammentCell.h"
#import "CMGroupInfoWireframe.h"
#import "CMCammentOverlayLayoutConfig.h"
#import "CMAdsVideoPlayerNode.h"
#import "CMVideoAd.h"
#import "CMOpenURLHelper.h"
#import "CMCammentCellDisplayingContext.h"

@interface CMCammentViewController () <CMCammentButtonDelegate, CMAdsVideoPlayerNodeDelegate>

@property CMOnboardingAlertType currentOnboardingAlert;
@property (nonatomic, strong) AMPopTip *popTip;

@end

@implementation CMCammentViewController

- (instancetype)initWithOverlayLayoutConfig:(CMCammentOverlayLayoutConfig *)overlayLayoutConfig {
    self = [super initWithNode:[[CMCammentsOverlayViewNode alloc] initWithLayoutConfig:overlayLayoutConfig]];
    if (self) {
        self.currentOnboardingAlert = CMOnboardingAlertNone;
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.node.cammentButton.delegate = self;
    self.node.delegate = self;
    self.node.adsVideoPlayerNode.delegate = self;

    [self.sidebarWireframe addToViewController:self];
    self.node.leftSidebarNode = self.sidebarWireframe.view.node;

    [self setupBindings];
    [self.presenter setupView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.presenter checkIfNeedForOnboarding];
    [self updateCameraOrientation];
    [self updateOverlayNodeOrientation];
}

- (void)askForSetupPermissions {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:CMLocalized(@"setup.use_camment_chat")
                                                                             message:CMLocalized(@"setup.what_is_camment")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"setup.sounds_fun")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [self.presenter setupCameraSession];
                                                          [self updateCameraOrientation];
                                                          [self.presenter readyToShowOnboarding];
                                                      }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"setup.maybe_later")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          [self.presenter sendOnboardingEvent:CMOnboardingEvent.OnboardingPostponed];
                                                      }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showToolTip:(NSString *)text anchorFrame:(CGRect)frame direction:(AMPopTipDirection)direction delay:(NSTimeInterval)delay inView:(UIView *)view maxWidth:(CGFloat)maxWidth {
    if (self.popTip) {
        [self.popTip hideForced:YES];
    }

    self.popTip = [AMPopTip new];
    self.popTip.padding = 9.0f;
    self.popTip.arrowSize = CGSizeMake(18, 10);
    self.popTip.actionAnimation = AMPopTipActionAnimationFloat;
    self.popTip.edgeMargin = 14.0f;
    self.popTip.popoverColor = UIColorFromRGB(0x9B9B9B);
    self.popTip.radius = 8.0f;
    self.popTip.actionFloatOffset = 3.0f;
    self.popTip.shouldDismissOnSwipeOutside = NO;
    self.popTip.shouldDismissOnTap = NO;
    self.popTip.shouldDismissOnTapOutside = NO;

    CGFloat duration = 0.f;

    if (self.currentOnboardingAlert == CMOnboardingAlertPostponedOnboardingReminder ||
            self.currentOnboardingAlert == CMOnboardingAlertSkippedOnboardingReminder) {
        // We dismiss it manually to prevent touch capturing by the tooltip view
        duration = 5.0f;
        __weak typeof(self) __weakSelf = self;
        [self.popTip setDismissHandler:^{
            __weakSelf.currentOnboardingAlert = CMOnboardingAlertNone;
        }];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popTip showText:text
                    direction:direction
                     maxWidth:maxWidth
                       inView:view ?: self.view
                    fromFrame:frame
                     duration:duration];
    });
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    CMOnboardingAlertType alertType = _currentOnboardingAlert;

    [self hideOnboardingAlert:[self currentOnboardingAlert]];
    [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context)
    {
        [self updateOverlayNodeOrientation];
    }  completion:^(id <UIViewControllerTransitionCoordinatorContext> context)
    {
        [self updateOverlayNodeOrientation];
        [self updateCameraOrientation];
        [self showOnboardingAlert:alertType];
    }];
}

- (void)updateCameraOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIInterfaceOrientationUnknown:
            break;
        case UIInterfaceOrientationPortrait:
            [self.presenter updateCameraOrientation:AVCaptureVideoOrientationPortrait];
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            [self.presenter updateCameraOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            [self.presenter updateCameraOrientation:AVCaptureVideoOrientationLandscapeLeft];
            break;
        case UIInterfaceOrientationLandscapeRight:
            [self.presenter updateCameraOrientation:AVCaptureVideoOrientationLandscapeRight];
            break;
    };
}

- (void)updateOverlayNodeOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self.node updateInterfaceOrientation:orientation];
}

- (void)setupBindings {
    __weak typeof(self) __weakSelf = self;
    [[[[RACObserve([CMStore instance], cammentRecordingState) distinctUntilChanged] takeUntil:self.rac_willDeallocSignal] deliverOnMainThread] subscribeNext:^(NSNumber *state) {
        typeof(__weakSelf) _self = __weakSelf;
        if (![_self.presenter isCameraSessionConfigured]) { return; }
        _self.node.showCammentRecorderNode = state.integerValue == CMCammentRecordingStateRecording;
        [_self.node transitionLayoutWithAnimation:YES
                               shouldMeasureAsync:NO
                            measurementCompletion:nil];
    }];
}

- (void)setCammentsBlockNodeDelegate:(id <CMCammentsBlockDelegate>)delegate {
    [self.node.cammentsBlockNode setDelegate:delegate];
    [delegate setItemCollectionDisplayNode:self.node.cammentsBlockNode.collectionNode];
}

- (void)didPressCammentButton {
    [self hideOnboardingAlert:CMOnboardingAlertTapAndHoldToRecordTooltip];
    [[CMStore instance] setCammentRecordingState:CMCammentRecordingStateRecording];
}

- (void)didReleaseCammentButton {
    [[CMStore instance] setCammentRecordingState:CMCammentRecordingStateFinished];
}

- (void)didCancelCammentButton {
    [[CMStore instance] setCammentRecordingState:CMCammentRecordingStateCancelled];
}

- (void)presenterDidRequestViewPreviewView {
    [_presenter connectPreviewViewToRecorder:[self.node.cammentRecorderNode scImageView]];
}

- (void)handleShareAction {
    [_presenter sendOnboardingEvent:CMOnboardingEvent.GroupInfoSidebarOpened];
    [_presenter inviteFriendsAction];
}

- (void)handlePanToShowSidebarGesture {
    [_presenter sendOnboardingEvent:CMOnboardingEvent.GroupInfoSidebarOpened];
}


- (void)didCompleteLayoutTransition {
    if (self.node.showCammentsBlock) {
        [self.presenter sendOnboardingEvent:CMOnboardingEvent.CammentBlockSwipedRight];
    } else {
        [self.presenter sendOnboardingEvent:CMOnboardingEvent.CammentBlockSwipedLeft];
    }
}

- (void)showOnboardingAlert:(CMOnboardingAlertType)type {
    if (self.node.showLeftSidebarNode) { return; }

    self.currentOnboardingAlert = type;

    UIView *view = nil;
    CGRect frame = CGRectNull;
    NSString *text = @"";
    AMPopTipDirection direction = AMPopTipDirectionDown;
    NSTimeInterval delay = 0.5;
    CGFloat maxWidth = .0f;

    switch (type) {
        case CMOnboardingAlertNone:
            break;
        case CMOnboardingAlertWouldYouLikeToChatAlert:
            break;
        case CMOnboardingAlertWhatIsCammentTooltip:
            break;
        case CMOnboardingAlertTapAndHoldToRecordTooltip:
            frame = self.node.cammentButton.frame;
            frame.origin.x += self.node.leftSidebarNode.frame.size.width;
            view = self.node.backgroundNode.view;
            text = CMLocalized(@"help.tap_and_hold_to_record");
            maxWidth = 150.0f;
            switch (self.node.layoutConfig.cammentButtonLayoutPosition) {

                case CMCammentOverlayLayoutPositionTopRight:
                    direction = AMPopTipDirectionDown;
                    break;
                case CMCammentOverlayLayoutPositionBottomRight:
                    direction = AMPopTipDirectionUp;
                    break;
            }

            break;
        case CMOnboardingAlertSwipeLeftToHideCammentsTooltip: {
            frame = self.node.cammentsBlockNode.bounds;
            frame.origin.x += self.node.leftSidebarNode.frame.size.width + 10;
            frame.size.width = 0.0f;
            view = self.node.backgroundNode.view;
            text = CMLocalized(@"help.swipe_left_to_hide_camments");
            direction = AMPopTipDirectionRight;
            maxWidth = 150.0f;
        }
            break;
        case CMOnboardingAlertSwipeRightToShowCammentsTooltip: {
            frame = self.node.cammentsBlockNode.bounds;
            frame.origin.x += self.node.leftSidebarNode.frame.size.width + frame.size.width;
            frame.size.width = 0.0f;
            view = self.node.backgroundNode.view;
            text = CMLocalized(@"help.swipe_right_to_show_camments");
            direction = AMPopTipDirectionRight;
            delay = 0.5;
            maxWidth = 150.0f;
        }
            break;
        case CMOnboardingAlertPullRightToInviteFriendsTooltip:
            frame = self.node.cammentsBlockNode.bounds;
            frame.origin.x += self.node.leftSidebarNode.frame.size.width + 10;
            frame.size.width = 0.0f;
            view = self.node.backgroundNode.view;
            text = CMLocalized(@"help.pull_right_to_invite_friends");
            direction = AMPopTipDirectionRight;
            delay = 0.5;
            maxWidth = 150.0f;
            break;
        case CMOnboardingAlertTapAndHoldToDeleteCammentsTooltip: {
            ASCellNode *node = [self.node.cammentsBlockNode.collectionNode nodeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            if (!node) {return;}
            CGRect nodeFrame = [self.node.leftSidebarNode.view convertRect:node.frame fromView:node.view];
            view = self.node.backgroundNode.view;
            frame = nodeFrame;
            direction = AMPopTipDirectionRight;
            maxWidth = 100.0f;
            text = CMLocalized(@"help.tap_and_hold_to_delete");
        }

            break;
        case CMOnboardingAlertTapToPlayCamment: {
            ASCellNode *node = [self.node.cammentsBlockNode.collectionNode nodeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            if (!node) {return;}
            CGRect nodeFrame = [self.node.leftSidebarNode.view convertRect:node.frame fromView:node.view];
            view = self.node.backgroundNode.view;
            frame = nodeFrame;
            direction = AMPopTipDirectionRight;
            maxWidth = 100;
            text = CMLocalized(@"help.tap_to_play");
        }
            break;
        case CMOnboardingAlertPostponedOnboardingReminder:
            frame = self.node.cammentButton.frame;
            frame.origin.x += self.node.leftSidebarNode.frame.size.width;
            view = self.node.backgroundNode.view;
            text = CMLocalized(@"help.postponed_onboarding_reminder");

            switch (self.node.layoutConfig.cammentButtonLayoutPosition) {

                case CMCammentOverlayLayoutPositionTopRight:
                    direction = AMPopTipDirectionDown;
                    break;
                case CMCammentOverlayLayoutPositionBottomRight:
                    direction = AMPopTipDirectionUp;
                    break;
            }
            maxWidth = 150;
            break;
        case CMOnboardingAlertSkippedOnboardingReminder:
            frame = self.node.cammentsBlockNode.bounds;
            frame.origin.x += self.node.leftSidebarNode.frame.size.width + 10;
            frame.size.width = 0.0f;
            view = self.node.backgroundNode.view;
            text = CMLocalized(@"help.continue_onboarding_later");
            direction = AMPopTipDirectionRight;
            delay = 0.5;
            maxWidth = 150;
            break;
    }

    if (CGRectIsNull(frame)) {return;}
    [self showToolTip:text
          anchorFrame:frame
            direction:direction
                delay:delay
               inView:view
             maxWidth:maxWidth];
}

- (void)hideOnboardingAlert:(CMOnboardingAlertType)type {
    if (_currentOnboardingAlert != type) {return;}
    self.currentOnboardingAlert = CMOnboardingAlertNone;
    [self.popTip hide];
}

- (void)presentCammentOptionsView:(CMCammentCell *)cammentCell actions:(CMCammentActionsMask)actions {
    if (actions == 0) {
        return;
    }

    CMCamment *camment = cammentCell.displayingContext.camment;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:CMLocalized(@"camment_actions.title")
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

    if (actions & CMCammentActionsMaskDelete) {
        [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"camment_actions.delete_camment")
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action) {
                                                              [self.presenter deleteCammentAction:camment];
                                                          }]];
    }

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"cancel")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                      }]];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [alertController setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [alertController
                popoverPresentationController];

        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionLeft;
        popPresenter.sourceView = cammentCell.view;
        popPresenter.sourceRect = cammentCell.view.bounds;
    }

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)presentViewController:(UIViewController *)controller {
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)showAllowCameraPermissionsView {
    [self.node.cammentButton cancelLongPressGestureRecognizer];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:CMLocalized(@"error.no_camera_permissions_title")]
                                                                             message:CMLocalized(@"error.no_camera_permissions_alert")
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"setup.maybe_later")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {

                                                      }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"error.open_settings")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                          [[CMOpenURLHelper new] openURL:settingsURL];
                                                      }]];
    [self presentViewController:alertController];
}

- (void)cmAdsVideoPlayerNodeDidClose {
    self.node.showVideoAdsPlayerNode = NO;
    [self.node setNeedsLayout];
    [self.node transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
}

- (void)playAdVideo:(CMVideoAd *)videoAd startingFromRect:(CGRect)startsRect {
    self.node.videoAdsPlayerNodeAppearsFrame = startsRect;
    [self.node.adsVideoPlayerNode play:videoAd];
    self.node.showVideoAdsPlayerNode = YES;
    [self.node setNeedsLayout];
    [self.node transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
}

- (void)setDisableHiddingCammentBlock:(BOOL)disableHiddingCammentBlock {
    self.node.disableClosingCammentBlock = disableHiddingCammentBlock;
    [self.node transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
}

- (void)handleSkipTutorialAction {
    [self.presenter sendOnboardingEvent:CMOnboardingEvent.OnboardingSkipped];
}

- (void)showSkipTutorialButton {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.node.showSkipTutorialButton = YES;
        [self.node transitionLayoutWithAnimation:YES
                              shouldMeasureAsync:NO
                           measurementCompletion:nil];
    });
}

- (void)updateContinueTutorialButtonState {
    [self.sidebarWireframe.presenter reloadData];
}

- (void)hideSkipTutorialButton:(BOOL)onboardingFinished {
    self.node.showSkipTutorialButton = NO;
    [self.node.skipTutorialButton setNeedsLayout];
    if (onboardingFinished) {
        [self.node transitionLayoutWithAnimation:YES
                              shouldMeasureAsync:NO
                           measurementCompletion:nil];
    } else {
        [self.node playSidebarJumpingAnimation];
    }
}

- (void)closeSidebarIfOpened:(void (^)())completion {
    if (!self.node.showLeftSidebarNode) {
        completion();
        return;
    }

    self.node.showLeftSidebarNode = NO;
    self.node.showCammentsBlock = YES;
    [self.node setNeedsLayout];
    [self.node updateLeftSideBarMenuLeftInset];
    [self.node transitionLayoutWithAnimation:YES
                          shouldMeasureAsync:NO
                       measurementCompletion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion();
    });
}

@end
