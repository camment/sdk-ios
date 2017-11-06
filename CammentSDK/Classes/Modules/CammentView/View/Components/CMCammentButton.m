//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <pop/POP.h>
#import "CMCammentButton.h"
#import "CMOneThirdScaleAnimation.h"
#import "CMHalfOpacityAnimation.h"

@interface CMCammentButton () <UIGestureRecognizerDelegate>
@property(nonatomic, strong) ASDisplayNode *cammentIcon;
@property(nonatomic, strong) UILongPressGestureRecognizer *gestureRecognizer;
@end

@implementation CMCammentButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.style.width = ASDimensionMake(65.0f);
        self.style.height = ASDimensionMake(65.0f);

        self.cammentIcon = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
            return [UIImageView new];
        } didLoadBlock:^(__kindof ASDisplayNode * _Nonnull node) {
            UIImageView *imageView = (UIImageView *)node.view;
            imageView.image = [UIImage imageNamed:@"cammentButton"
                                         inBundle:[NSBundle cammentSDKBundle]
                           compatibleWithTraitCollection:nil];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.backgroundColor = [UIColor clearColor];
        }];
        
        self.cammentIcon.style.width = ASDimensionMake(65.0f);
        self.cammentIcon.style.height = ASDimensionMake(65.0f);
        
        self.gestureRecognizer = [UILongPressGestureRecognizer new];
        self.gestureRecognizer.delegate = self;
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
    self.cammentIcon.layer.shadowOpacity = 1.0f;
    self.cammentIcon.layer.shadowOffset = CGSizeMake(.0f, .0f);
    self.view.alpha = 0.5;
}

- (void)handleLongPress:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded
            || sender.state == UIGestureRecognizerStateFailed
            || sender.state == UIGestureRecognizerStateCancelled) {
        [self pop_removeAllAnimations];
        [self pop_addAnimation:[CMOneThirdScaleAnimation scaleDownAnimation] forKey:@"scale"];
        [self pop_addAnimation:[CMHalfOpacityAnimation opacityDownAnimation] forKey:@"opacity"];
        if (sender.state == UIGestureRecognizerStateEnded) {
            [self.delegate didReleaseCammentButton];
        } else {
            [self.delegate didCancelCammentButton];
        }
    } else if (sender.state == UIGestureRecognizerStateBegan) {
        [self pop_removeAllAnimations];
        [self pop_addAnimation:[CMOneThirdScaleAnimation scaleUpAnimation] forKey:@"scale"];
        [self pop_addAnimation:[CMHalfOpacityAnimation opacityUpAnimation] forKey:@"opacity"];
        [self.delegate didPressCammentButton];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:_cammentIcon];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)cancelLongPressGestureRecognizer {
    [self.gestureRecognizer setEnabled:NO];
    [self.gestureRecognizer setEnabled:YES];
}

@end
