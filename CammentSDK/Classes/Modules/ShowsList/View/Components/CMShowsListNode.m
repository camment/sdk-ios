//
//  CMShowsListCMShowsListNode.m
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMShowsListNode.h"
#import "CMShowListNoShowsNode.h"

@interface CMShowsListNode ()

@property(nonatomic, strong) CMShowListNoShowsNode *noShowsNode;

@end

@implementation CMShowsListNode

- (instancetype)init {

    self = [super init];

    if (self) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 4.0f;
        layout.minimumInteritemSpacing = 4.0f;
        self.listNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];

        self.noShowsNode = [CMShowListNoShowsNode new];
        
        self.backgroundColor = [UIColor whiteColor];
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didLoad {
    [super didLoad];
    self.listNode.view.alwaysBounceVertical = YES;
}

- (void)setShowsListDelegate:(id <CMShowsListNodeDelegate>)delegate {
    self.listNode.delegate = delegate;
    self.listNode.dataSource = delegate;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero
                                                  child:_showEmptyView ? _noShowsNode : _listNode];
}

- (void)animateLayoutTransition:(nonnull id <ASContextTransitioning>)context {
    if (!_showEmptyView) {
        _noShowsNode.view.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        _listNode.view.frame = CGRectMake(0, self.bounds.size.height * 2, self.bounds.size.width, self.bounds.size.height);
    } else {
        _noShowsNode.view.frame = CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        _listNode.view.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        _noShowsNode.view.alpha = _showEmptyView ? 1 : 0;
        _listNode.view.alpha = _showEmptyView ? 0 : 1;
        
        if (_showEmptyView) {
            _noShowsNode.view.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            _listNode.view.frame = CGRectMake(0, self.bounds.size.height * 2, self.bounds.size.width, self.bounds.size.height);
        } else {
            _noShowsNode.view.frame = CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
            _listNode.view.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        }
        
    } completion:^(BOOL finished) {
        [context completeTransition:YES];
    }];
}

@end
