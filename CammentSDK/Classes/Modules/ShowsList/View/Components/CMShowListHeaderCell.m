//
// Created by Alexander Fedosov on 10.10.2017.
//

#import "CMShowListHeaderCell.h"
#import "CMStore.h"
#import "CMShowCellNode.h"
#import "UIColorMacros.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface CMShowListHeaderCell ()
@property(nonatomic, strong) ASTextNode *headerTextNode;
@property(nonatomic, strong) ASTextNode *onlineStatusTextNode;

@property(nonatomic, strong) ASButtonNode *passcodeButton;
@property(nonatomic, strong) ASButtonNode *tweaksButton;

@end

@implementation CMShowListHeaderCell {

}

- (instancetype)init {
    self = [super init];
    if (self) {

        self.passcodeButton = [[ASButtonNode alloc] init];
        [self.passcodeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Passcode"
                                                                                attributes:@{
                                                                                        NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
                                                                                        NSForegroundColorAttributeName: UIColorFromRGB(0x2b7cec)
                                                                                }]
                                       forState:UIControlStateNormal];

        self.tweaksButton = [[ASButtonNode alloc] init];
        [self.tweaksButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Settings"
                                                                                attributes:@{
                                                                                        NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
                                                                                        NSForegroundColorAttributeName: UIColorFromRGB(0x2b7cec)
                                                                                }]
                                       forState:UIControlStateNormal];

        self.headerTextNode = [ASTextNode new];
        self.headerTextNode.attributedText = [[NSAttributedString alloc] initWithString:@"Camment"
                                                                             attributes:@{
                                                                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:36],
                                                                                     NSForegroundColorAttributeName: [UIColor blackColor]
                                                                             }];
        self.onlineStatusTextNode = [ASTextNode new];
        [[[[RACSignal combineLatest:@[
                RACObserve([CMStore instance], isConnected),
                RACObserve([CMStore instance], isOfflineMode)
        ]] takeUntil:self.rac_willDeallocSignal] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
            NSNumber *isConnected = tuple.first;
            NSNumber *isOffline = tuple.second;

            NSString *title = @"online";
            if ([isOffline boolValue]) {
                title = @"offline";
            } else if (![isConnected boolValue]) {
                title = @"...connecting";
            }

            self.onlineStatusTextNode.attributedText = [[NSAttributedString alloc] initWithString:[title uppercaseString]
                                                                                       attributes:@{
                                                                                               NSFontAttributeName: [UIFont boldSystemFontOfSize:10],
                                                                                               NSForegroundColorAttributeName: [UIColor grayColor]
                                                                                       }];
            self.automaticallyManagesSubnodes = YES;
        }];

    }
    return self;
}

- (void)setDelegate:(id <CMShowCellNodeDelegate>)delegate {
    _delegate = delegate;

    [self.passcodeButton addTarget:delegate
                            action:@selector(showPasscodeView)
                  forControlEvents:ASControlNodeEventTouchUpInside];

    [self.tweaksButton addTarget:delegate
                          action:@selector(showTweaksView)
                forControlEvents:ASControlNodeEventTouchUpInside];
}


- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    ASStackLayoutSpec *buttonsStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:15.0f
                                                               justifyContent:ASStackLayoutJustifyContentStart
                                                                   alignItems:ASStackLayoutAlignItemsStart
                                                                     children:
                                                                             @[_passcodeButton
#ifdef INTERNALBUILD
                                                                             , _tweaksButton
#endif
                                                                             ]];

    ASStackLayoutSpec *headerStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:.0f
                                                               justifyContent:ASStackLayoutJustifyContentStart
                                                                   alignItems:ASStackLayoutAlignItemsStart
                                                                     children:@[_headerTextNode, _onlineStatusTextNode]];
    ASOverlayLayoutSpec *overlayLayoutSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:headerStack
                                                                                     overlay:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(INFINITY, INFINITY, 12, 0) child:buttonsStack]];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(INFINITY, 0, 0, 0) child:overlayLayoutSpec];

}

@end
