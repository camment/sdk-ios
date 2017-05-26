//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <pop/POP.h>
#import "CMCammentButton.h"
#import "CMOneThirdScaleAnimation.h"
#import "CMHalfOpacityAnimation.h"

@interface CMCammentButton () <UIGestureRecognizerDelegate>
@property(nonatomic, strong) ASImageNode *cammentIcon;
@property(nonatomic, strong) UILongPressGestureRecognizer *gestureRecognizer;
@end

@implementation CMCammentButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.style.width = ASDimensionMake(65.0f);
        self.style.height = ASDimensionMake(65.0f);

        self.cammentIcon = [ASImageNode new];
        self.cammentIcon.image = [UIImage imageNamed:@"cammentButton"];
        self.cammentIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.cammentIcon.backgroundColor = [UIColor clearColor];

        self.gestureRecognizer = [UILongPressGestureRecognizer new];
        self.gestureRecognizer.minimumPressDuration = 0.f;
        [self.gestureRecognizer addTarget:self action:@selector(handleLongPress:)];
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didLoad {
    [super didLoad];
    [self.cammentIcon.view setUserInteractionEnabled:YES];
    [self.cammentIcon.view addGestureRecognizer:_gestureRecognizer];
    self.cammentIcon.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cammentIcon.layer.shadowRadius = 2.0f;
    self.cammentIcon.layer.shadowOffset = CGSizeMake(.0f, .0f);
    self.view.alpha = 0.5;
}

- (void)handleLongPress:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded
            || sender.state == UIGestureRecognizerStateFailed
            || sender.state == UIGestureRecognizerStateCancelled) {
        [self pop_addAnimation:[CMOneThirdScaleAnimation scaleDownAnimation] forKey:@"scale"];
        [self pop_addAnimation:[CMHalfOpacityAnimation opacityDownAnimation] forKey:@"opacity"];
        [self.delegate didReleaseCammentButton];
    } else if (sender.state == UIGestureRecognizerStateBegan) {
        [self pop_addAnimation:[CMOneThirdScaleAnimation scaleUpAnimation] forKey:@"scale"];
        [self pop_addAnimation:[CMHalfOpacityAnimation opacityUpAnimation] forKey:@"opacity"];
        [self.delegate didPressCammentButton];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:_cammentIcon];
}

@end