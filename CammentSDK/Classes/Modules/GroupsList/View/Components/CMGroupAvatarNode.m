//
//  CMGroupAvatarNode.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 31.05.2018.
//

#import "CMGroupAvatarNode.h"
#import "NSArray+RacSequence.h"
#import "ASDimension.h"

const CGFloat spaceBetweenPhotos = 2.0f;

@interface CMGroupAvatarNode()

@property (nonatomic, strong) NSArray<NSString *> *imageUrls;
@property (nonatomic, strong) NSArray<ASNetworkImageNode *> *avatarNodes;

@end

@implementation CMGroupAvatarNode

- (instancetype)initWithImageUrls:(NSArray<NSString *> *)imageUrls {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageUrls = imageUrls;
        self.avatarNodes = [imageUrls map:^id(NSString *url) {
            ASNetworkImageNode *networkImageNode = [[ASNetworkImageNode alloc] init];
            [networkImageNode setURL:[[NSURL alloc] initWithString:url]];
            networkImageNode.contentMode = UIViewContentModeScaleAspectFill;
            networkImageNode.clipsToBounds = YES;
            return networkImageNode;
        }];

        self.clipsToBounds = YES;
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

+ (instancetype)nodeWithImageUrls:(NSArray<NSString *> *)imageUrls {
    return [[self alloc] initWithImageUrls:imageUrls];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    ASLayoutSpec *spec = [self singlePhotoLayout:constrainedSize];

    if (self.avatarNodes.count == 2) {
        spec = [self twoPhotosLayout:constrainedSize];
    } else if (self.avatarNodes.count == 3) {
        spec = [self threePhotosLayout:constrainedSize];
    } else if (self.avatarNodes.count > 3) {
        spec = [self multiplePhotosLayout:constrainedSize];
    }

    return spec;
}

- (ASLayoutSpec *)threePhotosLayout:(ASSizeRange)size {
    ASDisplayNode *node1 = self.avatarNodes[0];
    if (!node1) {
        node1 = [ASDisplayNode new];
    }

    node1.style.flexGrow = 1.0f;

    ASDisplayNode *node2 = self.avatarNodes[1];
    if (!node2) {
        node2 = [ASDisplayNode new];
    }

    node2.style.flexGrow = 1.0f;

    ASDisplayNode *node3 = self.avatarNodes[2];
    if (!node3) {
        node3 = [ASDisplayNode new];
    }

    node3.style.flexGrow = 1.0f;

    return [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1
                                                 child:[ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                               spacing:spaceBetweenPhotos
                                                                                        justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                                            alignItems:ASStackLayoutAlignItemsStretch
                                                                                              children:@[
                                                                                                      [ASRatioLayoutSpec ratioLayoutSpecWithRatio:2 child:[ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                                                                                                                                  spacing:spaceBetweenPhotos
                                                                                                                                                                                           justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                                                                                                                                               alignItems:ASStackLayoutAlignItemsStretch
                                                                                                                                                                                                 children:@[
                                                                                                                                                                                                         [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1 child:node1],
                                                                                                                                                                                                         [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1 child:node2],
                                                                                                                                                                                                 ]]],
                                                                                                      [ASRatioLayoutSpec ratioLayoutSpecWithRatio:2 child:node3],
                                                                                              ]]];
}

- (ASLayoutSpec *)multiplePhotosLayout:(ASSizeRange)size {
    ASDisplayNode *node1 = self.avatarNodes[0];
    if (!node1) {
        node1 = [ASDisplayNode new];
    }

    node1.style.flexGrow = 1.0f;

    ASDisplayNode *node2 = self.avatarNodes[1];
    if (!node2) {
        node2 = [ASDisplayNode new];
    }

    node2.style.flexGrow = 1.0f;

    ASDisplayNode *node3 = self.avatarNodes[2];
    if (!node3) {
        node3 = [ASDisplayNode new];
    }

    node3.style.flexGrow = 1.0f;

    ASDisplayNode *node4 = self.avatarNodes[3];
    if (!node4) {
        node4 = [ASDisplayNode new];
    }

    node4.style.flexGrow = 1.0f;

    return [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1
                                                 child:[ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                               spacing:spaceBetweenPhotos
                                                                                        justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                                            alignItems:ASStackLayoutAlignItemsStretch
                                                                                              children:@[
                                                                                                      [ASRatioLayoutSpec ratioLayoutSpecWithRatio:2 child:[ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                                                                                                                                  spacing:spaceBetweenPhotos
                                                                                                                                                                                           justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                                                                                                                                               alignItems:ASStackLayoutAlignItemsStretch
                                                                                                                                                                                                 children:@[
                                                                                                                                                                                                         [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1 child:node1],
                                                                                                                                                                                                         [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1 child:node2],
                                                                                                                                                                                                 ]]],
                                                                                                      [ASRatioLayoutSpec ratioLayoutSpecWithRatio:2 child:[ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                                                                                                                                  spacing:spaceBetweenPhotos
                                                                                                                                                                                           justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                                                                                                                                               alignItems:ASStackLayoutAlignItemsStretch
                                                                                                                                                                                                 children:@[
                                                                                                                                                                                                         [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1 child:node3],
                                                                                                                                                                                                         [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1 child:node4],
                                                                                                                                                                                                 ]]]
                                                                                              ]]];
}

- (ASLayoutSpec *)singlePhotoLayout:(ASSizeRange)constrainedSize {

    ASDisplayNode *node = self.avatarNodes.firstObject;
    if (!node) {
        node = [ASDisplayNode new];
    }

    node.style.flexGrow = 1.0f;

    return [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1 child:node];
}

- (ASLayoutSpec *)twoPhotosLayout:(ASSizeRange)constrainedSize {

    ASDisplayNode *node1 = self.avatarNodes[0];
    if (!node1) {
        node1 = [ASDisplayNode new];
    }

    node1.style.flexGrow = 1.0f;

    ASDisplayNode *node2 = self.avatarNodes[1];
    if (!node2) {
        node2 = [ASDisplayNode new];
    }

    node2.style.flexGrow = 1.0f;

    return [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1
                                                 child:[ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                               spacing:spaceBetweenPhotos
                                                                                        justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                                            alignItems:ASStackLayoutAlignItemsStretch
                                                                                              children:@[
                                                                                                      [ASRatioLayoutSpec ratioLayoutSpecWithRatio:2 child:node1],
                                                                                                      [ASRatioLayoutSpec ratioLayoutSpecWithRatio:2 child:node2],
                                                                                                      ]]];
}

@end
