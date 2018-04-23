//
// Created by Alexander Fedosov on 15.11.2017.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMCammentsBlockPresenterInput <NSObject, CMCammentsBlockDelegate>

@property NSArray *items;
@property NSArray *deletedCamments;

- (void)playCamment:(NSString *)cammentId;

- (void)insertNewItem:(CMCammentsBlockItem *)item completion:(void (^)(void))completion;

- (void)deleteItem:(CMCammentsBlockItem *)blockItem;
- (void)reloadItems:(NSArray<CMCammentsBlockItem *> *)newItems animated:(BOOL)animated;

- (void)updateItems:(NSArray<CMCammentsBlockItem *> *)items animated:(BOOL)animated;

- (void)updateCammentData:(CMCamment *)camment;

@end
