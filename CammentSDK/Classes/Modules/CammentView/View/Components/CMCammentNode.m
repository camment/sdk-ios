//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "CMCammentNode.h"
#import "CMCamment.h"
#import "CMStore.h"

@interface CMCammentNode () <ASVideoNodeDelegate>
@property(nonatomic, strong) ASVideoNode *videoPlayerNode;
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

        if (!_camment.thumbnailURL) {
            _videoPlayerNode.imageModificationBlock = ^UIImage * _Nullable(UIImage * _Nonnull image) {
                
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

    if (_camment.localAsset) {
        _videoPlayerNode.asset = _camment.localAsset;
        return;
    }
    
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
    if (_camment.thumbnailURL) {
        [_videoPlayerNode setURL:[[NSURL alloc] initWithString:_camment.thumbnailURL]];
    }
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
