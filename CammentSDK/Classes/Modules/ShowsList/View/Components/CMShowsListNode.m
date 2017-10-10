//
//  CMShowsListCMShowsListNode.m
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMShowsListNode.h"

@interface CMShowsListNode ()

@property(nonatomic, strong) ASDisplayNode *statusBarNode;

@end

@implementation CMShowsListNode

- (instancetype)init {

    self = [super init];

    if (self) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 30.0f;
        layout.minimumInteritemSpacing = 30.0f;
        self.listNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];

        self.statusBarNode = [ASDisplayNode new];
        self.statusBarNode.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];

        self.backgroundColor = [UIColor whiteColor];
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didLoad {
    [super didLoad];
    self.listNode.view.alwaysBounceVertical = YES;

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.listNode.view addSubview:self.refreshControl];
}

- (void)setShowsListDelegate:(id <CMShowsListNodeDelegate>)delegate {
    self.listNode.delegate = delegate;
    self.listNode.dataSource = delegate;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    BOOL isPortrait = UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation);
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    CGFloat statusBarHeight = (isPortrait ? statusBarSize.height : statusBarSize.width);

    _statusBarNode.style.height = ASDimensionMake(statusBarHeight);
    return [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_listNode
                                                   overlay:[ASInsetLayoutSpec
                                                           insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, INFINITY, 0)
                                                                               child:_statusBarNode]];
}

@end
