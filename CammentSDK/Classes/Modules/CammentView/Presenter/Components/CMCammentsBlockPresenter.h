//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMCammentsBlockNode.h"
#import "CMCamment.h"
#import "CMCammentsBlockItem.h"

@class CMCammentCell;

@protocol CMCammentsBlockPresenterOutput<NSObject>

- (void)presentCammentOptionsDialog:(CMCammentCell *)cammentCell;
- (void)runBotCammentAction:(CMBotAction *)action;
@end

@interface CMCammentsBlockPresenter: NSObject<CMCammentsBlockDelegate>

@property (nonatomic, strong) NSArray<CMCammentsBlockItem *> *items;
@property (nonatomic, weak) ASCollectionNode *collectionNode;
@property (nonatomic, weak) id<CMCammentsBlockPresenterOutput> output;

- (void)playCamment:(NSString *)cammentId;

- (void)insertNewItem:(CMCammentsBlockItem *)item completion:(void (^)())completion;

- (void)deleteItem:(CMCammentsBlockItem *)blockItem;
- (void)reloadItems:(NSArray<CMCammentsBlockItem *> *)newItems animated:(BOOL)animated;
@end
