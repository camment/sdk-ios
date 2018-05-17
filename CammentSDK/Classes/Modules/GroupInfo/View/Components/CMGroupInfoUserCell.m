//
// Created by Alexander Fedosov on 13.10.2017.
//

#import "CMGroupInfoUserCell.h"
#import "CMUser.h"
#import "UIColorMacros.h"
#import "CMUserContants.h"
#import "UIFont+CammentFonts.h"
#import <AsyncDisplayKit/ASLayoutElement.h>

@interface CMGroupInfoUserCell ()
@property(nonatomic, strong) ASTextNode *usernameNode;

@property(nonatomic, strong) ASDisplayNode *bottomSeparatorNode;
@property(nonatomic, strong) CMUser *user;
@property(nonatomic, strong) ASNetworkImageNode *userpicImageNode;
@property(nonatomic, strong) ASImageNode *onlineStatusNode;
@property(nonatomic, readonly) BOOL showBlockUnblockUserButton;

@property(nonatomic, strong) ASButtonNode *blockUserButtonNode;
@property(nonatomic, strong) ASButtonNode *unblockUserButtonNode;

@end

@implementation CMGroupInfoUserCell {

}


- (instancetype)initWithUser:(CMUser *)user showBlockUnblockUserButton:(BOOL)showDeleteUserButton {
    self = [super init];
    if (self) {
        self.user = user;
        _showBlockUnblockUserButton = showDeleteUserButton;
        
        self.backgroundColor = [UIColor whiteColor];

        self.userpicImageNode = [ASNetworkImageNode new];
        self.userpicImageNode.clipsToBounds = YES;
        self.userpicImageNode.contentMode = UIViewContentModeScaleAspectFill;
        
        self.usernameNode = [ASTextNode new];
        self.usernameNode.maximumNumberOfLines = 1;
        self.usernameNode.truncationMode = NSLineBreakByTruncatingTail;
        self.usernameNode.attributedText = [[NSAttributedString alloc] initWithString:user.username ?: @""
                                                                             attributes:@{
                                                                                     NSFontAttributeName: [UIFont nunitoMediumWithSize:14],
                                                                                     NSForegroundColorAttributeName: [UIColor blackColor]
                                                                             }];

        self.bottomSeparatorNode = [ASDisplayNode new];
        self.bottomSeparatorNode.backgroundColor = [UIColorFromRGB(0x4A4A4A) colorWithAlphaComponent:0.3];
        ((ASLayoutElementStyle *)self.bottomSeparatorNode.style).height = ASDimensionMake(1.0f);

        self.blockUserButtonNode = [ASButtonNode new];
        [self.blockUserButtonNode setImage:[UIImage imageNamed:@"block_icon"
                                                       inBundle:[NSBundle cammentSDKBundle]
                                  compatibleWithTraitCollection:nil]
                                   forState:UIControlStateNormal];
        [self.blockUserButtonNode addTarget:self
                                      action:@selector(didHandleBlockUserAction)
                            forControlEvents:ASControlNodeEventTouchUpInside];

        self.unblockUserButtonNode = [ASButtonNode new];
        [self.unblockUserButtonNode setImage:[UIImage imageNamed:@"unblock_icon"
                                                      inBundle:[NSBundle cammentSDKBundle]
                                 compatibleWithTraitCollection:nil]
                                  forState:UIControlStateNormal];
        [self.unblockUserButtonNode addTarget:self
                                     action:@selector(didHandleUnblockUserAction)
                           forControlEvents:ASControlNodeEventTouchUpInside];

        self.onlineStatusNode = [ASImageNode new];
        self.onlineStatusNode.contentMode = UIViewContentModeCenter;

        if (self.user.blockStatus == CMUserBlockStatus.Blocked) {
            self.usernameNode.alpha = .3f;
            self.userpicImageNode.alpha = .5;
            self.userpicImageNode.imageModificationBlock = ^UIImage *(UIImage *image) {

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

- (void)didHandleUnblockUserAction {
    [self.delegate useCell:self didHandleUnblockUserAction:self.user];
}

- (void)didHandleBlockUserAction {
    [self.delegate useCell:self didHandleBlockUserAction:self.user];
}

- (void)didLoad {
    [super didLoad];

    NSString *userStatusImage = @"offline_status_icn";
    if ([self.user.onlineStatus isEqualToString:CMUserOnlineStatus.Online]) {
        userStatusImage = @"online_status_icn";
    } else if ([self.user.onlineStatus isEqualToString:CMUserOnlineStatus.Broadcasting]) {
        userStatusImage = @"video_sync_icn";
    }

    self.onlineStatusNode.image = [UIImage imageNamed:userStatusImage inBundle:[NSBundle cammentSDKBundle] compatibleWithTraitCollection:nil];

    if (!self.user.userPhoto) return;

    NSURL *userpicURL = [[NSURL alloc] initWithString:self.user.userPhoto];
    if (!userpicURL) return;
    
    [self.userpicImageNode setURL:userpicURL resetToDefault:NO];
}


- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    _userpicImageNode.style.width = ASDimensionMake(36.0f);
    _userpicImageNode.style.height = ASDimensionMake(36.0f);
    _userpicImageNode.cornerRadius = 18.0f;
    _userpicImageNode.clipsToBounds = YES;

    _usernameNode.style.flexGrow = .0f;
    _usernameNode.style.flexShrink = 1.0f;
    _usernameNode.style.minHeight = ASDimensionMake(20.0f);

    _onlineStatusNode.style.width = ASDimensionMake(19.0f);
    _onlineStatusNode.style.height = ASDimensionMake(14.0f);

    NSMutableArray *stackLayoutChildren = [NSMutableArray arrayWithArray:@[_userpicImageNode, _usernameNode, _onlineStatusNode]];

    if (self.showBlockUnblockUserButton) {
        ASDisplayNode *button = [self.user.blockStatus isEqualToString:CMUserBlockStatus.Active] ? _blockUserButtonNode : _unblockUserButtonNode;
        button.style.preferredSize = CGSizeMake(44.0f, 44.0f);
        ASRatioLayoutSpec *spec = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1
                                                                        child:button];
        [stackLayoutChildren addObject:spec];
    }
    
    ASInsetLayoutSpec * insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:
                                     UIEdgeInsetsMake(
                                                      self.showBlockUnblockUserButton ? .0f : 5.0f,
                                                      10.0f,
                                                      self.showBlockUnblockUserButton ? .0f : 5.0f,
                                                      self.showBlockUnblockUserButton ? 2.0f : 10.0f)
                                                                           child:[ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                                                         spacing:5.0f
                                                                                                                  justifyContent:ASStackLayoutJustifyContentStart
                                                                                                                      alignItems:ASStackLayoutAlignItemsCenter
                                                                                                                        children:stackLayoutChildren]];
    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                   spacing:.0f
                                            justifyContent:ASStackLayoutJustifyContentStart
                                                alignItems:ASStackLayoutAlignItemsStretch
                                                  children:@[insetSpec, _bottomSeparatorNode]];
}

@end
