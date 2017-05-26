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
@end

@implementation CMShowsListNode

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 4.0f;
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)setShowsListDelegate:(id <CMShowsListNodeDelegate>)delegate {
    self.delegate = delegate;
    self.dataSource = delegate;
}


@end
