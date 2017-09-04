//
// Created by Alexander Fedosov on 20.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "CMCammentOverlayController.h"
#import "CMCammentsLoaderInteractorOutput.h"
#import "CMCammentRecorderInteractorOutput.h"
#import <AsyncDisplayKit/ASCollectionNode.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMCammentViewWireframe.h"
#import "CMShow.h"
#import "CMStore.h"

@interface CMCammentOverlayController ()
@property(nonatomic, strong) CMCammentViewController *cammentViewController;
@property (nonatomic, weak) CMCammentViewWireframe *wireframe;
@property(nonatomic, strong) RACDisposable *disposable;
@end

@implementation CMCammentOverlayController

- (instancetype)initWithShowMetadata:(CMShowMetadata *_Nonnull)metadata {
    self = [super init];
    if (self) {
        CMStore *store = [CMStore instance];
        store.currentShowMetadata = metadata;

        CMCammentViewWireframe *viewWireframe = [[CMCammentViewWireframe alloc] initWithShowMetadata:metadata];
        self.cammentViewController = [viewWireframe controller];
        self.wireframe = viewWireframe;

        [RACObserve(store, cammentRecordingState) subscribeNext:^(id x) {
            CMCammentRecordingState recordingState = (CMCammentRecordingState) [(NSNumber *)x integerValue];
            if (recordingState == CMCammentRecordingStateRecording) {
                if (self.overlayDelegate && [self.overlayDelegate respondsToSelector:@selector(cammentOverlayDidStartRecording)]) {
                    [self.overlayDelegate cammentOverlayDidStartRecording];
                }
            } else {
                if (self.overlayDelegate && [self.overlayDelegate respondsToSelector:@selector(cammentOverlayDidFinishRecording)]) {
                    [self.overlayDelegate cammentOverlayDidFinishRecording];
                }
            }
        }];

        [RACObserve(store, playingCammentId) subscribeNext:^(id x) {
            if (![(NSString *)x isEqualToString:kCMStoreCammentIdIfNotPlaying]) {
                if (self.overlayDelegate && [self.overlayDelegate respondsToSelector:@selector(cammentOverlayDidStartPlaying)]) {
                    [self.overlayDelegate cammentOverlayDidStartPlaying];
                }
            } else {
                if (self.overlayDelegate && [self.overlayDelegate respondsToSelector:@selector(cammentOverlayDidFinishPlaying)]) {
                    [self.overlayDelegate cammentOverlayDidFinishPlaying];
                }
            }
        }];
    }
    return self;
}

- (void)addToParentViewController:(UIViewController *)viewController {
    [viewController addChildViewController:self.cammentViewController];
    self.wireframe.parentViewController = viewController;
}

- (void)removeFromParentViewController {
    [self.cammentViewController removeFromParentViewController];
}

- (UIView *)cammentView {
    return [self.cammentViewController view];
}

- (void)setContentView:(UIView *_Nonnull)contentView {
    [self.cammentViewController.node setContentView:contentView];
}


- (UIInterfaceOrientationMask)contentPossibleOrientationMask {
    return [self.cammentViewController.presenter contentPossibleOrientationMask];
}

- (void)setCurrentShowMetadata:(CMShowMetadata *)metadata {
    [CMStore instance].currentShowMetadata = metadata;
}


@end
