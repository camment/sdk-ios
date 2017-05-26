//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMCammentsBlockNode.h"

@class Camment;


@interface CMCammentsBlockPresenter: NSObject<CMCammentsBlockDelegate>

@property (nonatomic, strong) NSArray<Camment *> *camments;
@property (nonatomic, weak) ASCollectionNode *collectionNode;

- (void)playCamment:(NSInteger)cammentId;

- (void)insertNewCamment:(Camment *)camment;
@end