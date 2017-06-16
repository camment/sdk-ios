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
#import "CMStreamPlayerNode.h"
#import "CMShow.h"
#import "CMContentViewerNode.h"
#import "Show.h"

@interface CMCammentsInStreamPlayerViewController () <CMCammentButtonDelegate, CMCammentsInStreamPlayerNodeDelegate>
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

    UISwipeGestureRecognizer *goBack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController)];
    goBack.direction = UISwipeGestureRecognizerDirectionRight;
    goBack.numberOfTouchesRequired = 2;
    [self.node.view addGestureRecognizer:goBack];

    self.node.cammentButton.delegate = self;
    self.node.delegate = self;

    [self setupBindings];
    [self.presenter setupView];
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

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setCammentsBlockNodeDelegate:(id <CMCammentsBlockDelegate>)delegate {
    [self.node.cammentsBlockNode setDelegate:delegate];
    [delegate setItemCollectionDisplayNode:self.node.cammentsBlockNode.collectionNode];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.presenter contentPossibleOrientationMask];
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

- (void)startShow:(Show *)show {
    [show.showType matchVideo:^(CMShow *matchedShow) {
        self.node.contentType = CMContentTypeVideo;
    } html:^(NSString *webURL) {
        self.node.contentType = CMContentTypeHTML;
    }];
    [self.node.contentViewerNode openContentAtUrl:[[NSURL alloc] initWithString:show.url]];
}

- (void)handleShareAction {
    [_presenter inviteFriendsAction];
}

@end
