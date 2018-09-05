//
//  CMGroupsListCMGroupsListPresenter.m
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMGroupsListPresenter.h"
#import "CMGroupsListWireframe.h"
#import "CMUsersGroup.h"
#import "CMStore.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "CMShowMetadata.h"
#import "TLIndexPathDataModel.h"
#import "CMAuthStatusChangedEventContext.h"
#import "CMGroupInfoPresenterOutput.h"
#import "CMProfileViewNodeContext.h"
#import "CMProfileViewNode.h"
#import "CMInviteFriendsGroupInfoNode.h"
#import "CMSmallTextHeaderCell.h"
#import "CMOpenURLHelper.h"
#import "TLIndexPathUpdates.h"
#import "CMGroupCellNode.h"
#import "CMUsersGroupBuilder.h"
#import <AWSCore/AWSCategory.h>
#import <CammentSDK/CammentSDK.h>
#import "CMAnalytics.h"

typedef NS_ENUM(NSInteger, CMGroupInfoSection) {
    CMGroupInfoSectionUserProfile,
    CMGroupInfoInviteFriendsSection,
    CMGroupInfoInviteFriendsSectionWithContinueTutorialButton,
    CMPublicGroupsListHeader,
    CMPrivateGroupsListHeader
};

@interface CMGroupsListPresenter ()<CMGroupListNodeDelegate>

@property (nonatomic, copy) NSArray<CMUsersGroup *> *userGroups;
@property(nonatomic, weak) ASCollectionNode *collectionNode;
@property(nonatomic) TLIndexPathDataModel *dataModel;
@property(nonatomic) BOOL showProfileInfo;

@end

@implementation CMGroupsListPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userGroups = [NSArray new];

        self.dataModel = [[TLIndexPathDataModel alloc] initWithItems:@[]];

        RACSignal *groupOrAuthStateChanged = [RACSignal combineLatest:@[
                [[[CMStore instance].authentificationStatusSubject
                        map:^id(CMAuthStatusChangedEventContext *authStatusChangedEventContext) {
                    return @(authStatusChangedEventContext.state);
                }] distinctUntilChanged],
                [[RACObserve([CMStore instance], activeGroup)
                        map:^NSString *(CMUsersGroup *  _Nullable activeGroup) {
                            return activeGroup.uuid;
                        }] distinctUntilChanged],
                [[RACObserve([CMStore instance], currentShowMetadata) map:^id(CMShowMetadata * metadata) {
                    return metadata.uuid;
                }] distinctUntilChanged]
        ]];
        @weakify(self);
        [[[[groupOrAuthStateChanged
                takeUntil:self.rac_willDeallocSignal] deliverOnMainThread] filter:^BOOL(RACTuple *tuple) {
            return tuple.third != nil;
        }] subscribeNext:^(RACTuple *tuple) {
            @strongify(self);

            NSNumber *authState = tuple.first;
            self.showProfileInfo = authState.integerValue == CMCammentUserAuthentificatedAsKnownUser;

            [self reloadData];
            [self reloadGroups];
        }];
    }

    return self;
}

- (void)groupListDidHandleRefreshAction:(UIRefreshControl *)refreshControl {
    [self reloadGroups];
}

-(void)dealloc{
    
}

- (void)setupView {
    [self reloadGroups];
}

- (void)reloadGroups {
    [CMStore instance].isFetchingGroupList = YES;
    [self.interactor fetchUserGroupsForShow:[CMStore instance].currentShowMetadata.uuid];
}

- (void)groupListInteractor:(id <CMGroupsListInteractorInput>)interactor didFetchUserGroups:(NSArray *)groups {
    [CMStore instance].isFetchingGroupList = NO;
    self.userGroups = [NSArray arrayWithArray:groups];
    [self reloadData];
}

- (void)groupListInteractor:(id <CMGroupsListInteractorInput>)interactor didFailToFetchUserGroups:(NSError *)error {
    DDLogError(@"Couldn't fetch user groups %@", error);
    [CMStore instance].isFetchingGroupList = NO;
}

- (void)reloadData {
    NSMutableArray *items = [NSMutableArray new];

    if (self.showProfileInfo) {
        [items addObject:@(CMGroupInfoSectionUserProfile)];

        if (self.userGroups.count == 0) {
            [self.output hideCreateGroupButton];
        } else {
            [self.output showCreateGroupButton];
        }
    } else {
        [self.output hideCreateGroupButton];
    }

    if (self.userGroups.count == 0 || !self.showProfileInfo) {
        [items addObject:@([CMStore instance].isOnboardingSkipped ? CMGroupInfoInviteFriendsSectionWithContinueTutorialButton : CMGroupInfoInviteFriendsSection)];
    } else {
        NSArray *privateGroups = [self.userGroups.rac_sequence filter:^BOOL(CMUsersGroup *group) {
            return !group.isPublic;
        }].array ?: @[];

        NSArray *publicGroups = [self.userGroups.rac_sequence filter:^BOOL(CMUsersGroup *group) {
            return group.isPublic;
        }].array ?: @[];

        if (publicGroups.count > 0) {
            [items addObject:@(CMPublicGroupsListHeader)];
            [items addObjectsFromArray:[publicGroups sortedArrayUsingComparator:^NSComparisonResult(CMUsersGroup * obj1, CMUsersGroup * obj2) {
                return [[NSDate aws_dateFromString:obj2.timestamp] compare:[NSDate aws_dateFromString:obj1.timestamp]];
            }]];
        }

        if (privateGroups.count > 0) {
            [items addObject:@(CMPrivateGroupsListHeader)];
            [items addObjectsFromArray:[privateGroups sortedArrayUsingComparator:^NSComparisonResult(CMUsersGroup * obj1, CMUsersGroup * obj2) {
                return [[NSDate aws_dateFromString:obj2.timestamp] compare:[NSDate aws_dateFromString:obj1.timestamp]];
            }]];
        }
    }

    TLIndexPathDataModel *updatedModel = [[TLIndexPathDataModel alloc] initWithItems:items];
    [self updateDataModel:updatedModel];
}

- (void)setItemCollectionDisplayNode:(ASCollectionNode *)node {
    self.collectionNode = node;
    [self reloadData];
}

- (void)groupInfoDidPressCreateGroupButton {
    [[CammentSDK instance] leaveCurrentChatGroup];
    [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventCreateGroup];
    [self handleDidTapInviteFriendsButton];
}


- (void)groupInfoDidPressInviteButton {
    [self handleDidTapInviteFriendsButton];
}

- (void)groupInfoDidPressBackButton {

}


- (void)updateDataModel:(TLIndexPathDataModel *)dataModel {
    TLIndexPathDataModel *oldDataModel = self.dataModel;
    self.dataModel = dataModel;

    TLIndexPathUpdates *updates = [[TLIndexPathUpdates alloc] initWithOldDataModel:oldDataModel
                                                                  updatedDataModel:self.dataModel
                                                       modificationComparatorBlock:^BOOL(id item1, id item2) {
                                                            return YES;
                                                       }];

    id item = [self.userGroups.rac_sequence filter:^BOOL(CMUsersGroup * value) {
        return [value.uuid isEqualToString:[CMStore instance].activeGroup.uuid];
    }].array.firstObject;

    NSIndexPath *indexPathToHighlight = nil;
    if (item) {
        indexPathToHighlight = [dataModel indexPathForItem:item];
    }

    [self.collectionNode performBatchUpdates:^{

        if (updates.insertedSectionNames.count) {
            NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
            for (NSString *sectionName in updates.insertedSectionNames) {
                NSInteger section = [updates.updatedDataModel sectionForSectionName:sectionName];
                [indexSet addIndex:(NSUInteger) section];
            }
            [self.collectionNode insertSections:indexSet];
        }

        if (updates.deletedSectionNames.count) {
            NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
            for (NSString *sectionName in updates.deletedSectionNames) {
                NSInteger section = [updates.oldDataModel sectionForSectionName:sectionName];
                [indexSet addIndex:(NSUInteger) section];
            }
            [self.collectionNode deleteSections:indexSet];
        }

        if (updates.insertedItems.count) {
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            for (id item in updates.insertedItems) {
                NSIndexPath *indexPath = [updates.updatedDataModel indexPathForItem:item];
                [indexPaths addObject:indexPath];
            }
            [self.collectionNode insertItemsAtIndexPaths:indexPaths];
        }

        if (updates.deletedItems.count) {
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            for (id item in updates.deletedItems) {
                NSIndexPath *indexPath = [updates.oldDataModel indexPathForItem:item];
                [indexPaths addObject:indexPath];
            }
            [self.collectionNode deleteItemsAtIndexPaths:indexPaths];
        }

        if (updates.movedItems.count) {
            for (id item in updates.movedItems) {
                NSIndexPath *oldIndexPath = [updates.oldDataModel indexPathForItem:item];
                NSIndexPath *updatedIndexPath = [updates.updatedDataModel indexPathForItem:item];

                NSString *oldSectionName = [updates.oldDataModel sectionNameForSection:oldIndexPath.section];
                NSString *updatedSectionName = [updates.updatedDataModel sectionNameForSection:updatedIndexPath.section];
                BOOL oldSectionDeleted = [updates.deletedSectionNames containsObject:oldSectionName];
                BOOL updatedSectionInserted = [updates.insertedSectionNames containsObject:updatedSectionName];
                if (oldSectionDeleted && updatedSectionInserted) {
                } else if (oldSectionDeleted) {
                    [self.collectionNode insertItemsAtIndexPaths:@[updatedIndexPath]];
                } else if (updatedSectionInserted) {
                    [self.collectionNode deleteItemsAtIndexPaths:@[oldIndexPath]];
                    [self.collectionNode insertItemsAtIndexPaths:@[updatedIndexPath]];
                } else {
                    [self.collectionNode moveItemAtIndexPath:oldIndexPath toIndexPath:updatedIndexPath];
                }

            }
        }
    }                             completion:^(BOOL finished)
    {
        if (indexPathToHighlight) {
            [self.collectionNode selectItemAtIndexPath:indexPathToHighlight
                                              animated:NO
                                        scrollPosition:UICollectionViewScrollPositionNone];
        } else {
            for (NSIndexPath *indexpath in [self.collectionNode indexPathsForSelectedItems]) {
                [self.collectionNode deselectItemAtIndexPath:indexpath animated:NO];
            }
        }
    }];
}


- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return [self.dataModel numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return [self.dataModel numberOfSections];
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {

    __weak typeof(self) weakSelf = self;
    __block ASCellNodeBlock cellNodeBlock = nil;

    id model = [self.dataModel itemAtIndexPath:indexPath];

    if ([model isKindOfClass:[NSNumber class]]) {
        CMGroupInfoSection section = (CMGroupInfoSection) [model integerValue];
        switch (section) {
            case CMGroupInfoSectionUserProfile: {
                CMProfileViewNodeContext *context = [CMProfileViewNodeContext new];
                context.shouldDisplayLeaveGroupButton = false;
                context.onLeaveGroupBlock = ^{
                };
                context.onLogout = ^{
                    [self handleDidTapLogoutButton];
                };
                context.delegate = self;

                cellNodeBlock = ^ASCellNode *() {
                    return [[CMProfileViewNode alloc] initWithContext:context];
                };
                break;
            }
            case CMGroupInfoInviteFriendsSectionWithContinueTutorialButton:
            case CMGroupInfoInviteFriendsSection: {
                BOOL showContinueTutorialButton = [CMStore instance].isOnboardingSkipped;
                cellNodeBlock = ^ASCellNode *() {
                    CMInviteFriendsGroupInfoNode *inviteFriendsGroupInfoNode = [CMInviteFriendsGroupInfoNode new];
                    inviteFriendsGroupInfoNode.delegate = weakSelf;
                    inviteFriendsGroupInfoNode.showContinueTutorialButton = showContinueTutorialButton;
                    return inviteFriendsGroupInfoNode;
                };
                break;
            }
            case CMPublicGroupsListHeader:
                cellNodeBlock = ^ASCellNode *() {
                    return [[CMSmallTextHeaderCell alloc] initWithText:CMLocalized(@"header.text.special_guest")];
                };
                break;
            case CMPrivateGroupsListHeader:
                cellNodeBlock = ^ASCellNode *() {
                    return [[CMSmallTextHeaderCell alloc] initWithText:CMLocalized(@"header.text.camment_chat")];
                };
                break;
        }
    } else {
        CMUsersGroup *group = model;
        return ^ASCellNode * {
            return [[CMGroupCellNode alloc] initWithGroup:group];
        };
    }

    return cellNodeBlock;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = [self.dataModel itemAtIndexPath:indexPath];

    if ([model isKindOfClass:[CMUsersGroup class]]) {
        [self.delegate didSelectGroup:model];
    }
}

- (void)handleDidTapInviteFriendsButton {
    [[[CMStore instance] inviteFriendsActionSubject] sendNext:@YES];
}

- (void)handleDidTapContinueTutorialButton {
    [[[CMStore instance] startTutorial] sendNext:@YES];
}

- (void)handleDidTapLogoutButton {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:CMLocalized(@"alert.logout.title")
                                                                        message:CMLocalized(@"Logout from Facebook account will remove your from current discussion.")
                                                                 preferredStyle:UIAlertControllerStyleAlert];

    [controller addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Logout") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[CammentSDK instance] logOut];
    }]];

    [controller addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];

    [[[CammentSDK instance] sdkUIDelegate] cammentSDKWantsPresentViewController:controller];
}

@end
