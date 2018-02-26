//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMCammentsBlockNode.h"
#import "CMCamment.h"
#import "CMCammentsBlockItem.h"
#import "CMCammentsBlockPresenterInput.h"

@class CMCammentCell;

@protocol CMCammentsBlockPresenterOutput<NSObject>

- (void)presentCammentOptionsDialog:(CMCammentCell *)cammentCell;
- (void)runBotCammentAction:(CMBotAction *)action;

- (BOOL)loaderCanLoadMoreCamments;

- (void)fetchNextPageOfCamments:(ASBatchContext *)context;
@end

@interface CMCammentsBlockPresenter: NSObject<CMCammentsBlockDelegate, CMCammentsBlockPresenterInput>

@property (strong) NSArray<CMCammentsBlockItem *> *items;
@property (strong) NSArray<CMCamment *> *deletedCamments;

@property (nonatomic, weak) ASCollectionNode *collectionNode;
@property (nonatomic, weak) id<CMCammentsBlockPresenterOutput> output;
@end
