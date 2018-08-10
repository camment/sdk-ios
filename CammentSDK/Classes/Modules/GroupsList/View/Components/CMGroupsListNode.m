//
//  CMGroupsListCMGroupsListNode.m
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "ASCollectionNode.h"
#import "ASTableNode.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMAuthStatusChangedEventContext.h"
#import "CMGroupsListNode.h"
#import "CMInviteFriendsButton.h"
#import "CMGroupInfoCollectionViewDelegate.h"
#import "UIFont+CammentFonts.h"
#import "CMStore.h"

@interface CMGroupsListNode ()

@property(nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation CMGroupsListNode

- (instancetype)init {
    self = [super init];
    if (self) {

        self.collectionNode = [[ASCollectionNode alloc] initWithLayoutDelegate:[CMGroupInfoCollectionViewDelegate new]
                                                             layoutFacilitator:nil];

        self.createNewGroupButton = [CMCreateGroupButton new];
        self.createNewGroupButton.style.height = ASDimensionMake(44.0f);
        [self.createNewGroupButton addTarget:self
                                     action:@selector(handleInviteButtonPress) forControlEvents:ASControlNodeEventTouchUpInside];

        [[[RACObserve([CMStore instance], isFetchingGroupList) takeUntil:self.rac_willDeallocSignal] deliverOnMainThread] subscribeNext:^(NSNumber *isFetchingGroupList) {
            if (isFetchingGroupList.boolValue) {
                [self.refreshControl beginRefreshing];
            } else {
                [self.refreshControl endRefreshing];
            }
        }];
        
        self.backgroundColor = [UIColor clearColor];
        self.automaticallyManagesSubnodes = YES;

    }

    return self;
}

- (void)didLoad {
    [super didLoad];
//    CMAuthStatusChangedEventContext *context = [CMStore instance].authentificationStatusSubject.first;
//    if (context.state == CMCammentUserAuthentificatedAsKnownUser) {
//        self.refreshControl = [UIRefreshControl new];
//        [self.refreshControl addTarget:self action:@selector(handlerRefreshAction) forControlEvents:UIControlEventValueChanged];
//        self.collectionNode.view.alwaysBounceVertical = YES;
//        [self.collectionNode.view addSubview:self.refreshControl];
//    } else {
//        self.refreshControl = nil;
//    }
    
    [[[[CMStore instance].authentificationStatusSubject takeUntil:self.rac_willDeallocSignal] deliverOnMainThread]
     subscribeNext:^(CMAuthStatusChangedEventContext * _Nullable context) {
         
         if (context.state == CMCammentUserAuthentificatedAsKnownUser) {
             
             if (!self.refreshControl) {
                 self.refreshControl = [UIRefreshControl new];
                 [self.refreshControl addTarget:self action:@selector(handlerRefreshAction) forControlEvents:UIControlEventValueChanged];
                 self.collectionNode.view.alwaysBounceVertical = YES;
                 [self.collectionNode.view addSubview:self.refreshControl];
                 }
             
         } else {
             [self.refreshControl removeFromSuperview];
             self.collectionNode.view.alwaysBounceVertical = NO;
             self.refreshControl = nil;
         }
     }];
}

- (void)handlerRefreshAction {
    if ([self.delegate respondsToSelector:@selector(groupListDidHandleRefreshAction:)]) {
        [self.delegate groupListDidHandleRefreshAction:self.refreshControl];
    }
}

- (void)handleInviteButtonPress {
    [self.delegate groupInfoDidPressCreateGroupButton];
}

- (void)setDelegate:(id <CMGroupListNodeDelegate>)delegate {
    _delegate = delegate;
    _collectionNode.delegate = _delegate;
    _collectionNode.dataSource = _delegate;
    [_delegate setItemCollectionDisplayNode:_collectionNode];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *layoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                            spacing:.0f
                                                                     justifyContent:ASStackLayoutJustifyContentStart
                                                                         alignItems:ASStackLayoutAlignItemsStretch
                                                                           children: _showCreateGroupButton ? @[_collectionNode, _createNewGroupButton] : @[_collectionNode]];
    _collectionNode.style.flexGrow = 1;
    layoutSpec.style.flexGrow = 1;

    return layoutSpec;
}

- (void)setAlpha:(CGFloat)alpha {
    self.collectionNode.alpha = alpha;
}

- (CGFloat)alpha {
    return self.collectionNode.alpha;
}

- (void)endRefreshing {
    [self.refreshControl endRefreshing];
}

@end
