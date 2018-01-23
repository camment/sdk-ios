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
                                                      handler:^(UIAlertAction *action) {}]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showToolTip:(NSString *)text
        anchorFrame:(CGRect)frame
          direction:(AMPopTipDirection)direction
              delay:(NSTimeInterval)delay {
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
    self.popTip.swipeRemoveGestureDirection = UISwipeGestureRecognizerDirectionDown
            | UISwipeGestureRecognizerDirectionUp
            | UISwipeGestureRecognizerDirectionLeft
            | UISwipeGestureRecognizerDirectionRight;
    self.popTip.shouldDismissOnSwipeOutside = YES;
    self.popTip.shouldDismissOnTap = YES;
    self.popTip.shouldDismissOnTapOutside = YES;
    self.popTip.actionFloatOffset = 3.0f;

    if (self.currentOnboardingAlert == CMOnboardingAlertTapToPlayCamment) {
        // We dismiss it manually to prevent touch capturing by the tooltip view
        self.popTip.shouldDismissOnTapOutside = NO;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popTip showText:text
                    direction:direction
                     maxWidth:self.view.frame.size.width - 60.0f
                       inView:self.view
                    fromFrame:frame];
    });
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    CMOnboardingAlertType alertType = _currentOnboardingAlert;

    [self hideOnboardingAlert:[self currentOnboardingAlert]];
    [coordinator animateAlongsideTransition:nil
                                 completion:^(id <UIViewControllerTransitionCoordinatorContext> context)
                                 {
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

- (void)setupBindings {
    [[[RACObserve([CMStore instance], cammentRecordingState) takeUntil:self.rac_willDeallocSignal] deliverOnMainThread] subscribeNext:^(NSNumber *state) {
        self.node.showCammentRecorderNode = state.integerValue == CMCammentRecordingStateRecording;
        [self.node transitionLayoutWithAnimation:YES
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
    [_presenter completeActionForOnboardingAlert:CMOnboardingAlertPullRightToInviteFriendsTooltip];
    [_presenter inviteFriendsAction];
}

- (void)handlePanToShowSidebarGesture {
    if (self.presenter.currentOnboardingStep != CMOnboardingAlertPullRightToInviteFriendsTooltip) {
        return;
    }

    [self.presenter completeActionForOnboardingAlert:CMOnboardingAlertPullRightToInviteFriendsTooltip];
}


- (void)didCompleteLayoutTransition {
    if (self.presenter.currentOnboardingStep == CMOnboardingAlertSwipeRightToShowCammentsTooltip
            || self.presenter.currentOnboardingStep == CMOnboardingAlertSwipeLeftToHideCammentsTooltip) {
        [self.presenter completeActionForOnboardingAlert:self.presenter.currentOnboardingStep];
    }
}

- (void)showOnboardingAlert:(CMOnboardingAlertType)type {
    if (self.node.showLeftSidebarNode) { return; }
    
    self.currentOnboardingAlert = type;

    CGRect frame = CGRectNull;
    NSString *text = @"";
    AMPopTipDirection direction = AMPopTipDirectionDown;
    NSTimeInterval delay = 0.5;

    switch (type) {
        case CMOnboardingAlertNone:
            break;
        case CMOnboardingAlertWouldYouLikeToChatAlert:
            break;
        case CMOnboardingAlertWhatIsCammentTooltip:
            break;
        case CMOnboardingAlertTapAndHoldToRecordTooltip:
            frame = self.node.cammentButton.frame;
            text = CMLocalized(@"help.tap_and_hold_to_record");
            
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
            frame = self.node.leftSidebarNode.frame;
            text = CMLocalized(@"help.swipe_left_to_hide_camments");
            direction = AMPopTipDirectionRight;
        }
            break;
        case CMOnboardingAlertSwipeRightToShowCammentsTooltip: {
            frame = self.node.cammentsBlockNode.frame;
            frame.origin.x = 10.0f;
            frame.size.width = 0.0f;
            text = CMLocalized(@"help.swipe_right_to_show_camments");
            direction = AMPopTipDirectionRight;
            delay = 0.5;
        }
            break;
        case CMOnboardingAlertPullRightToInviteFriendsTooltip:
            frame = self.node.leftSidebarNode.frame;
            text = CMLocalized(@"help.pull_right_to_invite_friends");
            direction = AMPopTipDirectionRight;
            delay = 0.5;
            break;
        case CMOnboardingAlertTapAndHoldToDeleteCammentsTooltip: {
            ASCellNode *node = [self.node.cammentsBlockNode.collectionNode nodeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            if (!node) {return;}
            frame = node.frame;
            frame = [self.view convertRect:frame fromView:node.view];
            text = CMLocalized(@"help.tap_and_hold_to_delete");
        }

            break;
        case CMOnboardingAlertTapToPlayCamment: {
            ASCellNode *node = [self.node.cammentsBlockNode.collectionNode nodeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            if (!node) {return;}
            frame = node.frame;
            frame = [self.view convertRect:frame fromView:node.view];
            text = CMLocalized(@"help.tap_to_play");
        }
            break;
    }

    if (CGRectIsNull(frame)) {return;}
    [self showToolTip:text anchorFrame:frame direction:direction delay:delay];
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
    [self.node transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
}

- (void)playAdVideo:(CMVideoAd *)videoAd startingFromRect:(CGRect)startsRect {
    self.node.videoAdsPlayerNodeAppearsFrame = startsRect;
    [self.node.adsVideoPlayerNode play:videoAd];
    self.node.showVideoAdsPlayerNode = YES;
    [self.node transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
}

@end
