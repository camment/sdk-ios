//
// Created by Alexander Fedosov on 19.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMShowsListNode.h"
#import "CMShowsListCollectionPresenterOutput.h"

@class ASCollectionNode;
@class Show;

@interface CMShowsListCollectionPresenter: NSObject <CMShowsListNodeDelegate>

@property (nonatomic, weak) id<CMShowsListCollectionPresenterOutput> output;

@property (nonatomic, strong) NSArray<Show *> *shows;
@property (nonatomic, weak) ASCollectionNode *collectionNode;

@end