//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerViewController.m
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "CMCammentsInStreamPlayerViewController.h"
#import "CMCammentsInStreamPlayerNode.h"
#import "CMCammentButton.h"
#import "CMStore.h"
#import "CMCammentRecorderPreviewNode.h"

@interface CMCammentsInStreamPlayerViewController () <CMCammentButtonDelegate>
@end

@implementation CMCammentsInStreamPlayerViewController

- (instancetype)init {
    self = [super initWithNode:[CMCammentsInStreamPlayerNode new]];
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

    [self setupBindings];
    [self.presenter setupView];
}

- (void)setupBindings {
    __weak typeof(self) __weakSelf = self;
    [RACObserve([CMStore instance], isRecordingCamment) subscribeNext:^(NSNumber *isRecording) {
        typeof(self) strongSelf = __weakSelf;
        if (!strongSelf) {return;}
        strongSelf.node.showCammentRecorderNode = isRecording.boolValue;
        [strongSelf.node transitionLayoutWithAnimation:YES shouldMeasureAsync:YES measurementCompletion:nil];
    }];
}

- (void)setCammentsBlockNodeDelegate:(id <CMCammentsBlockDelegate>)delegate {
    [self.node.cammentsBlockNode setDelegate:delegate];
    [delegate setItemCollectionDisplayNode:self.node.cammentsBlockNode.collectionNode];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotate {
    return YES;
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
    [[CMStore instance] setIsRecordingCamment:YES];
}

- (void)didReleaseCammentButton {
    [[CMStore instance] setIsRecordingCamment:NO];
}

- (void)presenterDidRequestViewPreviewView {
    [_presenter connectPreviewViewToRecorder:(SCImageView *) [self.node.cammentRecorderNode scImageView]];
}

@end