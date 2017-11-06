//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@protocol CMCammentsBlockDelegate<ASCollectionDelegate, ASCollectionDataSource>
 - (void)setItemCollectionDisplayNode:(ASCollectionNode *)node;
@end

@interface CMCammentsBlockNode: ASDisplayNode

@property(nonatomic, strong) ASCollectionNode *collectionNode;

- (void)setDelegate:(id<CMCammentsBlockDelegate>)delegate;

@end
