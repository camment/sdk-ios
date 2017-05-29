//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//
#import "SCFilterImageView.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <pop/POP.h>
#import "CMCammentRecorderPreviewNode.h"
#import "UIColorMacros.h"


@interface CMCammentRecorderPreviewNode ()

@property(nonatomic, strong) ASDisplayNode * cameraPreviewNode;
@property(nonatomic, strong) ASDisplayNode * recordIndicatorNode;

@end

@implementation CMCammentRecorderPreviewNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cameraPreviewNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * {
            SCFilterImageView *view = [SCFilterImageView new];
            view.contextType = SCContextTypeEAGL;
            view.scaleAndResizeCIImageAutomatically = YES;
            view.contentMode = UIViewContentModeScaleAspectFill;
            [view loadContextIfNeeded];
            return view;
        } didLoadBlock:^(__kindof ASDisplayNode *node) {

        }];

        self.recordIndicatorNode = [ASDisplayNode new];
        self.recordIndicatorNode.backgroundColor = [UIColor redColor];

        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.cameraPreviewNode.borderColor = UIColorFromRGB(0x3B3B3B).CGColor;
        self.cameraPreviewNode.borderWidth = 2.0f;
        self.cameraPreviewNode.cornerRadius = 4.0f;
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didLoad {
    [super didLoad];

    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    animation.fromValue = @.0f;
    animation.toValue = @1.0f;
    animation.repeatForever = YES;
    animation.autoreverses = YES;
    [self.recordIndicatorNode pop_addAnimation:animation forKey:@"Blinking"];
}

- (void)layout {
    [super layout];
    self.layer.masksToBounds = YES;
    self.cameraPreviewNode.view.clipsToBounds = YES;
    self.cameraPreviewNode.view.layer.masksToBounds = YES;
    self.cameraPreviewNode.view.frame = self.cameraPreviewNode.bounds;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    _cameraPreviewNode.style.width = ASDimensionMake(90);
    _cameraPreviewNode.style.height = ASDimensionMake(90);

    _recordIndicatorNode.style.width = ASDimensionMake(12);
    _recordIndicatorNode.style.height = ASDimensionMake(12);
    _recordIndicatorNode.cornerRadius = 6.0f;

    ASStackLayoutSpec *layout =  [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                         spacing:2.0f
                                                                  justifyContent:ASStackLayoutJustifyContentStart
                                                                      alignItems:ASStackLayoutAlignItemsStart
                                                                        flexWrap:ASStackLayoutFlexWrapNoWrap
                                                                    alignContent:ASStackLayoutAlignContentStart
                                                                        children:@[
                                                                                _cameraPreviewNode,
                                                                                _recordIndicatorNode
                                                                        ]];
    return layout;
}

- (SCFilterImageView *)scImageView {
    if ([NSThread currentThread] != [NSThread mainThread]) {
        NSLog(@"Coudn't operate with UIKit layer in background thread");
        return nil;
    }
    return (SCFilterImageView *) _cameraPreviewNode.view;
}


@end
