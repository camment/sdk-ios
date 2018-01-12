//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMCammentsBlockPresenter.h"
#import "CMCammentCell.h"
#import "CMCammentNode.h"
#import "CMStore.h"
#import "CMBotCammentCell.h"
#import "AWSCognito.h"
#import "NSArray+RacSequence.h"
#import "CMCammentBuilder.h"
#import "AWSS3Model.h"
#import "CMAdsDemoBot.h"
#import "CMCammentCellDisplayingContext.h"
#import "CMAuthStatusChangedEventContext.h"

@interface CMCammentsBlockPresenter () <CMBotCammentCellDelegate, CMCammentCellDelegate>

@property(nonatomic, strong) NSOperationQueue *updatesQueue;
@property(nonatomic, strong) NSString *userCognitoUuid;

@end
@implementation CMCammentsBlockPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.items = @[];
        self.deletedCamments = @[];
        self.updatesQueue = [[NSOperationQueue alloc] init];
        self.updatesQueue.underlyingQueue = dispatch_get_main_queue();
        self.updatesQueue.maxConcurrentOperationCount = 1;
        [self.updatesQueue setSuspended:NO];

        [[[CMStore instance].authentificationStatusSubject takeUntil:self.rac_willDeallocSignal]
                subscribeNext:^(CMAuthStatusChangedEventContext *x) {
            self.userCognitoUuid = x.user.cognitoUserId;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadItems:self.items animated:NO];
            });
        }];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(identityIdDidChange:)
                                                     name:AWSCognitoIdentityIdChangedNotification
                                                   object:nil];
    }

    return self;
}

- (void)identityIdDidChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *newIdentity = [userInfo objectForKey:AWSCognitoNotificationNewId];
    NSString *oldIdentity = [userInfo objectForKey:AWSCognitoNotificationPreviousId];
    NSArray *updatedItems = [self.items map:^CMCammentsBlockItem *(CMCammentsBlockItem *item) {

        __block CMCammentsBlockItem *updatedItem = item;
        [item matchCamment:^(CMCamment *camment) {
            if ([camment.userCognitoIdentityId isEqualToString:oldIdentity]) {
                updatedItem = [CMCammentsBlockItem
                        cammentWithCamment:[[[CMCammentBuilder cammentFromExistingCamment:camment]
                                withUserCognitoIdentityId:newIdentity]
                                build]];
            }
        }       botCamment:^(CMBotCamment *botCamment) {

        }];

        return updatedItem;
    }];

    self.userCognitoUuid = [[CMStore instance].authentificationStatusSubject.first user].cognitoUserId ?: self.userCognitoUuid;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadItems:updatedItems animated:YES];
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setItemCollectionDisplayNode:(ASCollectionNode *)node {
    _collectionNode = node;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode
     numberOfItemsInSection:
             (NSInteger)section {
    return [self.items count];
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return 1;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    CMCammentsBlockItem *item = self.items[(NSUInteger) indexPath.row];
    NSString *userCognitoUuid = self.userCognitoUuid;
    return ^ASCellNode * {
        __block ASCellNode *node;
        [item matchCamment:^(CMCamment *camment) {
            CMCammentCellDisplayingContext *context = [[CMCammentCellDisplayingContext alloc] initWithCamment:camment
                                                                                     shouldShowDeliveryStatus:[camment.userCognitoIdentityId isEqualToString:userCognitoUuid] shouldShowWatchedStatus:![camment.userCognitoIdentityId isEqualToString:userCognitoUuid]];
            node = [[CMCammentCell alloc] initWithDisplayContext:context];
            [(CMCammentCell *) node setDelegate:self];
        }       botCamment:^(CMBotCamment *botCamment) {
            node = [[CMBotCammentCell alloc] initWithBotCamment:botCamment];
            [(CMBotCammentCell *) node setDelegate:self];
        }];

        return node;
    };
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:
                                (UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:
                (NSInteger)section {
    UIEdgeInsets result = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
    return result;
}

- (void)playCamment:(NSString *)cammentId {
    for (ASCellNode *node in _collectionNode.visibleNodes) {
        if (![node isKindOfClass:[CMCammentCell class]]) { continue; }

        CMCammentCell *cammentCell = (CMCammentCell *)node;
        BOOL oldExpandedValue = cammentCell.expanded;
        BOOL shouldPlay = [cammentCell.cammentNode.camment.uuid isEqualToString:cammentId] && !cammentCell.cammentNode.isPlaying;

        if (shouldPlay) {
            if (!cammentCell.displayingContext.camment.status.isWatched) {
                CMCamment *updatedCamment = [[[CMCammentBuilder cammentFromExistingCamment:cammentCell.displayingContext.camment]
                        withStatus:[[CMCammentStatus alloc] initWithDeliveryStatus:cammentCell.displayingContext.camment.status.deliveryStatus
                                                                         isWatched:YES]] build];
                [self updateCammentData:updatedCamment];
            }

            [cammentCell.cammentNode playCamment];
        } else {
            [cammentCell.cammentNode stopCamment];
        }

        if (oldExpandedValue == shouldPlay) { continue; }

        cammentCell.expanded = shouldPlay;
        [cammentCell invalidateCalculatedLayout];
        [cammentCell transitionLayoutWithAnimation:YES
                                shouldMeasureAsync:NO
                             measurementCompletion:nil];
    }
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CMCammentsBlockItem *cammentsBlockItem = self.items[(NSUInteger) indexPath.row];
    [cammentsBlockItem matchCamment:^(CMCamment *camment) {
        BOOL shouldPlay = ![camment.uuid isEqualToString:[[CMStore instance] playingCammentId]];
        [[CMStore instance] setPlayingCammentId:shouldPlay ? camment.uuid : kCMStoreCammentIdIfNotPlaying];
    }                    botCamment:^(CMBotCamment *botCamment) {

        ASCellNode *node = [collectionNode nodeForItemAtIndexPath:indexPath];
        CGRect frame = node.frame;
        frame = [collectionNode.supernode.view convertRect:frame fromView:node.view];

        CMBotAction *action = botCamment.botAction;
        NSMutableDictionary *params = [(NSDictionary *) botCamment.botAction.params mutableCopy];
        params[kCMAdsDemoBotRectParam] = [NSValue valueWithCGRect:frame];
        action.params = params;
        [self.output runBotCammentAction:action];
    }];
}

- (void)insertNewItem:(CMCammentsBlockItem *)item completion:(void (^)(void))completion {
    [self.updatesQueue addOperationWithBlock:^{
        [_collectionNode performBatchAnimated:YES updates:^{
            @synchronized (self.items) {
                self.items = [@[item] arrayByAddingObjectsFromArray:[_items copy]];
            }
            [_collectionNode insertItemsAtIndexPaths:@[
                    [NSIndexPath indexPathForItem:0 inSection:0]
            ]];
        }                          completion:^(BOOL completed) {
            if (completion) {
                completion();
            }
        }];
    }];
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    __block CGSize result = CGSizeZero;

    CMCammentsBlockItem *cammentsBlockItem = self.items[(NSUInteger) indexPath.row];
    [cammentsBlockItem matchCamment:^(CMCamment *camment) {
        result = camment.uuid == [CMStore instance].playingCammentId ? CGSizeMake(90.0f, 90.0f) : CGSizeMake(45.0f, 45.0f);
    }                    botCamment:^(CMBotCamment *ads) {
        result = CGSizeMake(45.0f, 45.0f);
    }];

    return ASSizeRangeMake(result);
}

- (void)botCammentCellDidTapOnCloseButton:(CMBotCammentCell *)cell {

    NSIndexPath *indexPath = [_collectionNode indexPathForNode:cell];
    [self removeItemAtIndexPath:indexPath];
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath && indexPath.row < _items.count && indexPath.row >= 0) {
        NSMutableArray *mutableItems = [[NSMutableArray alloc] initWithArray:_items copyItems:YES];
        [mutableItems removeObjectAtIndex:(NSUInteger) indexPath.row];
        self.items = mutableItems;
        [_collectionNode performBatchAnimated:YES updates:^{
            [_collectionNode deleteItemsAtIndexPaths:@[
                    indexPath
            ]];
        }                          completion:nil];
    }
}

- (void)cammentCellDidHandleLongPressAction:(CMCammentCell *)cell {
    if (self.output && [self.output respondsToSelector:@selector(presentCammentOptionsDialog:)]) {
        [self.output presentCammentOptionsDialog:cell];
    }
}

- (void)markCammentAsDeleted:(CMCamment *)camment {
    self.deletedCamments = [self.deletedCamments arrayByAddingObject:camment];
}

- (void)deleteItem:(CMCammentsBlockItem *)blockItem {
    for (NSUInteger i = 0; i < self.items.count; i++) {
        CMCammentsBlockItem *item = self.items[i];
        [blockItem matchCamment:^(CMCamment *camment) {
            [item matchCamment:^(CMCamment *itemCamment) {
                if ([camment.uuid isEqualToString:itemCamment.uuid]){
                    [self markCammentAsDeleted:camment];
                    [self removeItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                }
            }       botCamment:^(CMBotCamment *ads) {
            }];
        }            botCamment:^(CMBotCamment *ads) {
        }];
    }
}

- (void)reloadItems:(NSArray<CMCammentsBlockItem *> *)newItems
           animated:(BOOL)animated {
    if (!animated) {
        @synchronized (self.items) {
            self.items = newItems;
        }
        [self.collectionNode reloadData];
    } else {
        NSMutableArray<NSIndexPath *> *itemsToRemove = [NSMutableArray new];
        NSMutableArray<NSIndexPath *> *itemsToInsert = [NSMutableArray new];

        for (int i = 0; i < _items.count; i++) {
            [itemsToRemove addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }

        for (int i = 0; i < newItems.count; i++) {
            [itemsToInsert addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }

        @synchronized (self.items) {
            self.items = newItems;
        }

        [self.collectionNode performBatchAnimated:YES
                                          updates:^{
                                              if ([itemsToRemove count] > 0) {
                                                  [self.collectionNode deleteItemsAtIndexPaths:itemsToRemove];
                                              }

                                              if ([itemsToInsert count] > 0) {
                                                  [self.collectionNode insertItemsAtIndexPaths:itemsToInsert];
                                              }
                                          }
                                       completion:^(BOOL finished) {
                                       }];
    }
}


- (void)updateCammentData:(CMCamment *)camment {
    @synchronized (self.items) {
        __block CMCamment *mergedCamment = nil;
        self.items = [self.items map:^CMCammentsBlockItem *(CMCammentsBlockItem *item) {
            __block CMCammentsBlockItem *updatedItem = item;
            [item matchCamment:^(CMCamment *oldCamment) {
                if ([oldCamment.uuid isEqualToString:camment.uuid]) {
                    CMCammentStatus *status = [[CMCammentStatus alloc]
                            initWithDeliveryStatus:MAX(oldCamment.status.deliveryStatus, camment.status.deliveryStatus)
                                         isWatched:oldCamment.status.isWatched ?: camment.status.isWatched];
                    mergedCamment = [[[CMCammentBuilder cammentFromExistingCamment:camment]
                                      withStatus:status]
                                     build];
                    updatedItem = [CMCammentsBlockItem
                            cammentWithCamment:mergedCamment];
                }
            }       botCamment:^(CMBotCamment *botCamment) {
            }];

            return updatedItem;
        }];
        if (mergedCamment) {
            [self updateVisibleCellWithCamment:mergedCamment];
        }
    }
}

- (void)updateVisibleCellWithCamment:(CMCamment *)camment {
    [self.updatesQueue addOperationWithBlock:^{
        for (ASCellNode *node in _collectionNode.visibleNodes) {
            if (![node isKindOfClass:[CMCammentCell class]]) { continue; }
            CMCammentCell *cammentCell = (CMCammentCell *) node;
            if ([cammentCell.displayingContext.camment.uuid isEqualToString:camment.uuid]) {
                CMCammentCellDisplayingContext *context = [[CMCammentCellDisplayingContext alloc] initWithCamment:camment
                                                                                         shouldShowDeliveryStatus:[camment.userCognitoIdentityId isEqualToString:self.userCognitoUuid]
                                                                                          shouldShowWatchedStatus:![camment.userCognitoIdentityId isEqualToString:self.userCognitoUuid]];
                [cammentCell updateWithDisplayingContext:context];
            }
        }
    }];
}

@end
