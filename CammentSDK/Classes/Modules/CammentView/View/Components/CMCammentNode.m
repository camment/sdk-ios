//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "CMCammentNode.h"
#import "CMCamment.h"
#import "CMStore.h"
#import "UIColorMacros.h"

@interface CMCammentNode () <ASVideoNodeDelegate>

@end

@implementation CMCammentNode

- (instancetype)initWithCamment:(CMCamment *)camment {
    self = [super init];
    if (self) {
    
        self.camment = camment;
        self.videoPlayerNode = [ASVideoNode new];
        self.videoPlayerNode.shouldAutorepeat = NO;
        self.videoPlayerNode.shouldAutoplay = NO;
        self.videoPlayerNode.muted = NO;
        self.videoPlayerNode.delegate = self;
        self.videoPlayerNode.userInteractionEnabled = NO;

        self.videoPlayerNode.borderColor = UIColorFromRGB(0x3B3B3B).CGColor;
        self.videoPlayerNode.borderWidth = 2.0f;
        self.videoPlayerNode.cornerRadius = 4.0f;
        self.videoPlayerNode.cornerRoundingType = ASCornerRoundingTypeDefaultSlowCALayer;
        self.videoPlayerNode.clipsToBounds = YES;

        if (!_camment.thumbnailURL || _camment.localURL) {
            _videoPlayerNode.imageModificationBlock = ^UIImage *(UIImage *image) {

                CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
                CIContext *context = [CIContext contextWithOptions:nil];

                CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
                [filter setValue:inputImage forKey:kCIInputImageKey];
                [filter setValue:@(0.0) forKey:kCIInputSaturationKey];

                CIImage *outputImage = filter.outputImage;

                CGImageRef cgImageRef = [context createCGImage:outputImage fromRect:outputImage.extent];

                UIImage *result = [UIImage imageWithCGImage:cgImageRef];
                CGImageRelease(cgImageRef);

                return result;
            };
            
        }

        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didEnterPreloadState {
    [super didEnterPreloadState];
    
    [self setVideoAsset];
    
    if (_camment.thumbnailURL && !_camment.localURL) {
        [_videoPlayerNode setURL:[[NSURL alloc] initWithString:_camment.thumbnailURL]];
    }
}

- (void)didExitHierarchy {
    [super didExitHierarchy];
    [_videoPlayerNode pause];
}

- (void)setVideoAsset {
    NSURL *assetURL;
    BOOL localFileExists = NO;
    if (_camment.localURL != nil) {
        assetURL = [[NSURL alloc] initFileURLWithPath:_camment.localURL];
        localFileExists = [[NSFileManager defaultManager] fileExistsAtPath:_camment.localURL];
    }

    if (_camment.remoteURL != nil && !localFileExists) {
        assetURL = [[NSURL alloc] initWithString:_camment.remoteURL];
    }

    if (assetURL == nil) { return; }
    _videoPlayerNode.asset = [AVAsset assetWithURL:assetURL];
}

- (void)playCamment {
    if ([NSThread currentThread] != [NSThread mainThread]) {
        NSLog(@"Coudn't play camment in background thread!");
        return;
    }
    [_videoPlayerNode.player pause];
    [_videoPlayerNode.player seekToTime:kCMTimeZero];
    [_videoPlayerNode play];
}

- (void)stopCamment {
    if ([NSThread currentThread] != [NSThread mainThread]) {
        NSLog(@"Coudn't stop camment in background thread!");
        return;
    }

    [_videoPlayerNode.player pause];
    [_videoPlayerNode resetToPlaceholder];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASInsetLayoutSpec *layoutSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero
                                                                           child:[ASRatioLayoutSpec ratioLayoutSpecWithRatio:1.0f
                                                                                                                       child:_videoPlayerNode]];

    return layoutSpec;
}

- (void)animateLayoutTransition:(id<ASContextTransitioning>)context {
    if (![context isAnimated]) {
        [super animateLayoutTransition:context];
        return;
    }
    
    [UIView animateWithDuration:self.defaultLayoutTransitionDuration
                          delay: .0f
                        options: UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.videoPlayerNode.frame = [context finalFrameForNode:self.videoPlayerNode];
                     }                completion:^(BOOL finished) {
                         [context completeTransition:finished];
                     }];
}

- (BOOL)isPlaying {
    return [_videoPlayerNode isPlaying];
}

- (void)videoDidPlayToEnd:(ASVideoNode *)videoNode {
    [[CMStore instance] setPlayingCammentId: kCMStoreCammentIdIfNotPlaying];
}

- (void)videoNodeDidStartInitialLoading:(ASVideoNode *)videoNode {
    self.alpha = 0.2;
}

- (void)videoNodeDidFinishInitialLoading:(ASVideoNode *)videoNode {
    self.alpha = 1;
}

@end
