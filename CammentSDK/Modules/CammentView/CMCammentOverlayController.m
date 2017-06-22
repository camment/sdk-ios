//
// Created by Alexander Fedosov on 20.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "CMCammentOverlayController.h"
#import "CMCammentsLoaderInteractorOutput.h"
#import "CMCammentRecorderInteractorOutput.h"
#import <AsyncDisplayKit/ASCollectionNode.h>
#import "CMCammentViewWireframe.h"
#import "Show.h"
#import "CMStore.h"

@interface CMCammentOverlayController ()
@property(nonatomic, strong) CMCammentViewController *cammentViewController;
@property(nonatomic, strong) RACDisposable *disposable;
@end

@implementation CMCammentOverlayController

- (instancetype)initWithShow:(Show *)show {
    self = [super init];
    if (self) {
        self.cammentViewController = [[[CMCammentViewWireframe alloc] initWithShow:show] controller];
        __weak typeof(self) __weakSelf = self;
        CMStore *store = [CMStore instance];

        [RACObserve(store, cammentRecordingState) subscribeNext:^(id x) {
            CMCammentRecordingState recordingState = (CMCammentRecordingState) [(NSNumber *)x integerValue];
            if (recordingState == CMCammentRecordingStateRecording) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(cammentOverlayDidStartRecording)]) {
                    [self.delegate cammentOverlayDidStartRecording];
                }
            } else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(cammentOverlayDidFinishRecording)]) {
                    [self.delegate cammentOverlayDidFinishRecording];
                }
            }
        }];

        [RACObserve(store, playingCammentId) subscribeNext:^(id x) {
            if (![(NSString *)x isEqualToString:kCMStoreCammentIdIfNotPlaying]) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(cammentOverlayDidStartPlaying)]) {
                    [self.delegate cammentOverlayDidStartPlaying];
                }
            } else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(cammentOverlayDidFinishPlaying)]) {
                    [self.delegate cammentOverlayDidFinishPlaying];
                }
            }
        }];
    }
    return self;
}

- (void)addToParentViewController:(UIViewController *)viewController {
    [viewController addChildViewController:self.cammentViewController];
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
@end
