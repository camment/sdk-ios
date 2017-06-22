//
//  CMCammentViewCMCammentViewViewController.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import <AMPopTip.h>
#import "CMCammentViewController.h"
#import "CMCammentButton.h"
#import "CMStore.h"
#import "CMCammentsBlockNode.h"
#import "CMCammentRecorderPreviewNode.h"
#import "UIColorMacros.h"

@interface CMCammentViewController () <CMCammentButtonDelegate>
@property(nonatomic, strong) AMPopTip *popTip;
@end

@implementation CMCammentViewController

- (instancetype)init {
    self = [super initWithNode:[CMCammentViewNode new]];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UISwipeGestureRecognizer *hideCammentsBlockRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideCamments)];
    hideCammentsBlockRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.node.view addGestureRecognizer:hideCammentsBlockRecognizer];

    UISwipeGestureRecognizer *showCammentsBlockRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showCamments)];
    showCammentsBlockRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.node.view addGestureRecognizer:showCammentsBlockRecognizer];

    self.node.cammentButton.delegate = self;
    self.node.delegate = self;

    [self setupBindings];
    [self.presenter setupView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateCameraOrientation];
}

- (void)showToolTip {
    self.popTip = [AMPopTip new];
    self.popTip.padding = 9.0f;
    self.popTip.arrowSize = CGSizeMake(18, 10);
    self.popTip.actionAnimation = AMPopTipActionAnimationFloat;
    self.popTip.edgeMargin = 14.0f;
    self.popTip.popoverColor = UIColorFromRGB(0x9B9B9B);
    self.popTip.radius = 8.0f;
    self.popTip.shouldDismissOnTapOutside = YES;
    self.popTip.actionFloatOffset = 3.0f;
    [self.popTip showText:@"Tap & hold to record a mini video (camment)"
                direction:AMPopTipDirectionDown
                 maxWidth:self.view.frame.size.width - 60.0f
                   inView:self.view
                fromFrame:self.node.cammentButton.frame];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self updateCameraOrientation];
    }];
}

- (void)updateCameraOrientation {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        case UIDeviceOrientationLandscapeRight:
        case UIDeviceOrientationUnknown:
            [self.presenter updateCameraOrientation: AVCaptureVideoOrientationLandscapeLeft];
            break;
        case UIDeviceOrientationPortrait:
            [self.presenter updateCameraOrientation: AVCaptureVideoOrientationPortrait];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            [self.presenter updateCameraOrientation: AVCaptureVideoOrientationPortraitUpsideDown];
            break;
        case UIDeviceOrientationLandscapeLeft:
            [self.presenter updateCameraOrientation: AVCaptureVideoOrientationLandscapeRight];
            break;
        case UIDeviceOrientationFaceUp:break;
        case UIDeviceOrientationFaceDown:break;
    };
}

- (void)setupBindings {
    __weak typeof(self) __weakSelf = self;
    [RACObserve([CMStore instance], cammentRecordingState) subscribeNext:^(NSNumber *state) {
        typeof(self) strongSelf = __weakSelf;
        if (!strongSelf) {return;}
        strongSelf.node.showCammentRecorderNode = state.integerValue == CMCammentRecordingStateRecording;
        [strongSelf.node transitionLayoutWithAnimation:YES shouldMeasureAsync:YES measurementCompletion:nil];
    }];
}

- (void)setCammentsBlockNodeDelegate:(id <CMCammentsBlockDelegate>)delegate {
    [self.node.cammentsBlockNode setDelegate:delegate];
    [delegate setItemCollectionDisplayNode:self.node.cammentsBlockNode.collectionNode];
}

- (void)hideCamments {
    if (self.node.showCammentsBlock) {
        self.node.showCammentsBlock = NO;
        [self.node transitionLayoutWithAnimation:YES shouldMeasureAsync:YES measurementCompletion:nil];
    }
}

- (void)showCamments {
    if (!self.node.showCammentsBlock) {
        self.node.showCammentsBlock = YES;
        [self.node transitionLayoutWithAnimation:YES shouldMeasureAsync:YES measurementCompletion:nil];
    }
}

- (void)didPressCammentButton {
    [[CMStore instance] setCammentRecordingState:CMCammentRecordingStateRecording];
}

- (void)didReleaseCammentButton {
    [[CMStore instance] setCammentRecordingState:CMCammentRecordingStateFinished];
}

- (void)didCancelCammentButton {
    [[CMStore instance] setCammentRecordingState:CMCammentRecordingStateCancelled];
}

- (void)presenterDidRequestViewPreviewView {
    [_presenter connectPreviewViewToRecorder:(SCImageView *) [self.node.cammentRecorderNode scImageView]];
}

- (void)handleShareAction {
    [_presenter inviteFriendsAction];
}


@end
