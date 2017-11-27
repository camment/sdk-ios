//
//  CMCammentDeliveryIndicator.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 27.11.2017.
//

#import "CMCammentDeliveryIndicator.h"

@interface CMCammentDeliveryIndicator ()

@property(nonatomic, strong) ASImageNode *sentCheckMarkNode;
@property(nonatomic, strong) ASImageNode *deliveredCheckMarkNode;

@end

@implementation CMCammentDeliveryIndicator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sentCheckMarkNode = [[ASImageNode alloc] init];
        self.deliveredCheckMarkNode = [[ASImageNode alloc] init];
        self.sentCheckMarkNode.alpha = .0f;
        self.deliveredCheckMarkNode.alpha = .0f;
        
        self.automaticallyManagesSubnodes = YES;
    }
    return self;
}

- (void)didLoad {
    [super didLoad];

    UIImage *image = [UIImage imageNamed:@"checkmark"
                                inBundle:[NSBundle cammentSDKBundle]
           compatibleWithTraitCollection:nil];

    self.sentCheckMarkNode.image = image;
    self.deliveredCheckMarkNode.image = image;
}

- (void)setDeliveryStatus:(CMCammentDeliveryStatus)deliveryStatus {
    _deliveryStatus = deliveryStatus;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.deliveredCheckMarkNode.style.preferredSize = CGSizeMake(6, 7);
    self.sentCheckMarkNode.style.preferredSize = CGSizeMake(6, 7);
    ASStackLayoutSpec *layoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                            spacing:-1
                                                                     justifyContent:ASStackLayoutJustifyContentStart
                                                                         alignItems:ASStackLayoutAlignItemsStart
                                                                           children:@[
                                                                                   self.deliveredCheckMarkNode,
                                                                                   self.sentCheckMarkNode
                                                                           ]];
    return [ASWrapperLayoutSpec wrapperWithLayoutElement:layoutSpec];
}

- (void)animateLayoutTransition:(nonnull id <ASContextTransitioning>)context {
    if (![context isAnimated]) {
        self.sentCheckMarkNode.alpha = (_deliveryStatus != CMCammentDeliveryStatusNotSent);
        self.deliveredCheckMarkNode.alpha =
        (_deliveryStatus != CMCammentDeliveryStatusDelivered)
        || (_deliveryStatus != CMCammentDeliveryStatusSeen);
        [super animateLayoutTransition:context];
        return;
    }

    [UIView animateWithDuration:self.defaultLayoutTransitionDuration
                          delay:self.defaultLayoutTransitionDelay
                        options:self.defaultLayoutTransitionOptions
                     animations:^{
                         self.sentCheckMarkNode.alpha = (_deliveryStatus != CMCammentDeliveryStatusNotSent);
                         self.deliveredCheckMarkNode.alpha =
                                 (_deliveryStatus == CMCammentDeliveryStatusDelivered)
                                         || (_deliveryStatus == CMCammentDeliveryStatusSeen);
                     }
                     completion:^(BOOL finished) {
                         [context completeTransition:finished];
                     }];
}

@end
