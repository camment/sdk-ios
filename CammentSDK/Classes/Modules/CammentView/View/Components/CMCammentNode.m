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

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.cornerRadius = 4.0f;
        
        self.videoPlayerNode = [ASVideoNode new];
        self.videoPlayerNode.shouldAutorepeat = NO;
        self.videoPlayerNode.shouldAutoplay = NO;
        self.videoPlayerNode.muted = NO;
        self.videoPlayerNode.delegate = self;
        self.videoPlayerNode.userInteractionEnabled = NO;

        self.videoPlayerNode.borderColor = [UIColor whiteColor].CGColor;
        self.videoPlayerNode.borderWidth = 2.0f;
        self.videoPlayerNode.cornerRadius = 4.0f;
        self.videoPlayerNode.cornerRoundingType = ASCornerRoundingTypeDefaultSlowCALayer;
        self.videoPlayerNode.clipsToBounds = YES;

        self.playIconImageNode = [ASImageNode new];
        self.playIconImageNode.contentMode = UIViewContentModeScaleAspectFill;
        [self.playIconImageNode onDidLoad:^(__kindof ASImageNode *node) {
            node.image = [UIImage imageNamed:@"play_icon"
                                    inBundle:[NSBundle cammentSDKBundle]
               compatibleWithTraitCollection:nil];
        }];

        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}


- (instancetype)initWithCamment:(CMCamment *)camment {
    self = [self init];
    if (self) {
        self.camment = camment;
    }

    return self;
}

- (void)setCamment:(CMCamment *)camment {
    _camment = camment;
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
}

- (void)didEnterPreloadState {
    [super didEnterPreloadState];

    if (!_camment) { return; }

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

    if (!_camment) { return; }

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
    _playIconImageNode.alpha = .0f;
    [_videoPlayerNode.player pause];
    [_videoPlayerNode.player seekToTime:kCMTimeZero];
    [_videoPlayerNode play];
}

- (void)stopCamment {
    if ([NSThread currentThread] != [NSThread mainThread]) {
        NSLog(@"Coudn't stop camment in background thread!");
        return;
    }

    _playIconImageNode.alpha = 1.0f;
    [_videoPlayerNode.player pause];
    [_videoPlayerNode resetToPlaceholder];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    _playIconImageNode.style.width = ASDimensionMake(@"35%");
    _playIconImageNode.style.height = ASDimensionMake(@"35%");
    ASInsetLayoutSpec *insetLayoutSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(INFINITY, 0.0f, 0.0f, INFINITY) child:_playIconImageNode];
    ASInsetLayoutSpec *layoutSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero
                                                                           child:[ASRatioLayoutSpec ratioLayoutSpecWithRatio:1.0f
                                                                                                                       child:[ASOverlayLayoutSpec overlayLayoutSpecWithChild:_videoPlayerNode
                                                                                                                                                                     overlay:insetLayoutSpec]]];

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
    _playIconImageNode.alpha = 1.0f;
    if (self.onStoppedPlaying) {
        self.onStoppedPlaying();
    } else {
        [[CMStore instance] setPlayingCammentId: kCMStoreCammentIdIfNotPlaying];
    }
}

- (void)videoNodeDidStartInitialLoading:(ASVideoNode *)videoNode {
    self.videoPlayerNode.alpha = 0.2;
}

- (void)videoNodeDidFinishInitialLoading:(ASVideoNode *)videoNode {
    self.videoPlayerNode.alpha = 1;
}

@end
