//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMCammentsBlockNode.h"
#import "Camment.h"
#import "CammentsBlockItem.h"

@interface CMCammentsBlockPresenter: NSObject<CMCammentsBlockDelegate>

@property (nonatomic, strong) NSArray<CammentsBlockItem *> *items;
@property (nonatomic, weak) ASCollectionNode *collectionNode;

- (void)playCamment:(NSString *)cammentId;

- (void)insertNewItem:(CammentsBlockItem *)item;
@end
