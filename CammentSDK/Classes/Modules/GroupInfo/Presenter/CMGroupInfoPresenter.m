//
//  CMGroupInfoCMGroupInfoPresenter.m
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMGroupInfoPresenter.h"
#import "CMGroupInfoWireframe.h"
#import "CMStore.h"
#import "TLIndexPathDataModel.h"
#import "TLIndexPathUpdates.h"
#import "CMProfileViewNode.h"
#import "CMPeopleJoinedHeaderCell.h"
#import "CMGroupInfoUserCell.h"
#import "CMUserBuilder.h"
#import "CMUserSessionController.h"
#import "CMOpenURLHelper.h"
#import "CMCammentViewPresenterOutput.h"
#import "CMProfileViewNodeContext.h"
#import "CMUserContants.h"
#import "CammentSDK.h"
#import "CMErrorWireframe.h"

typedef NS_ENUM(NSInteger, CMGroupInfoSection) {
    CMGroupInfoSectionUserProfile,
    CMGroupInfoSectionUserProfileWithLeaveGroupButton,
    CMGroupInfoSectionUserProfileWithInviteButton,
    CMGroupInfoSectionUserProfileWithInviteButtonLeaveGroupButton,
    CMGroupInfoInviteFriendsSection,
    CMGroupInfoInviteFriendsSectionWithContinueTutorialButton,
    CMGroupInfoFriendsHeaderSection,
};

@interface CMGroupInfoPresenter () <CMGroupInfoUserCellDelegate>

@property(nonatomic, weak) ASCollectionNode *collectionNode;
@property(nonatomic) TLIndexPathDataModel *dataModel;
@property(nonatomic) NSArray<CMUser *> *users;
@property(nonatomic) BOOL showProfileInfo;
@property(nonatomic) BOOL haveUserDeletionPermissions;
@property(nonatomic) BOOL canLeaveTheGroup;
@property(nonatomic) NSString *groupHost;

@end

@implementation CMGroupInfoPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataModel = [[TLIndexPathDataModel alloc] initWithItems:@[]];

        RACSignal *groupOrAuthStateChanged = [RACSignal combineLatest:@[
                [CMStore instance].authentificationStatusSubject,
                [RACObserve([CMStore instance], activeGroup) distinctUntilChanged]
        ]];
        @weakify(self);
        [[[groupOrAuthStateChanged
                takeUntil:self.rac_willDeallocSignal] deliverOnMainThread]
                subscribeNext:^(RACTuple *tuple) {
                    @strongify(self);

                    CMAuthStatusChangedEventContext *authStatusChangedEventContext = tuple.first;
                    self.showProfileInfo = authStatusChangedEventContext.state == CMCammentUserAuthentificatedAsKnownUser;

                    CMUsersGroup *group = tuple.second;
                    self.groupHost = group.hostCognitoUserId;
                    self.haveUserDeletionPermissions = group && [group.ownerCognitoUserId isEqualToString:authStatusChangedEventContext.user.cognitoUserId];
                    self.canLeaveTheGroup = group && ![group.ownerCognitoUserId isEqualToString:authStatusChangedEventContext.user.cognitoUserId];
                    [self reloadData];
                }];

        [[[RACObserve([CMStore instance], activeGroupUsers)
                takeUntil:self.rac_willDeallocSignal]
                deliverOnMainThread] subscribeNext:^(NSArray *currentGroupUsers) {
            [self reloadData];
        }];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
};

- (void)reloadData {
    NSMutableArray *items = [NSMutableArray new];

    CMAuthStatusChangedEventContext *context = [CMStore instance].authentificationStatusSubject.first;
    self.users = [[CMStore instance].activeGroupUsers.rac_sequence filter:^BOOL(CMUser *user) {
        return ![user.cognitoUserId isEqualToString:context.user.cognitoUserId];
    }].array ?: @[];

    self.users = [[self.users.rac_sequence map:^id _Nullable(CMUser * _Nullable value) {
        return [[CMUserBuilder userFromExistingUser:value] build];
    }] filter:^BOOL(CMUser *user) {
        return user.username.length > 0;
    }].array ?: @[];

    self.users = [self.users sortedArrayUsingComparator:^NSComparisonResult(CMUser *obj1, CMUser *obj2) {
        if (![obj1.blockStatus isEqualToString:obj2.blockStatus]) {
            return [obj1.blockStatus isEqualToString:CMUserBlockStatus.Active] ? NSOrderedAscending : NSOrderedDescending;
        }

        return [obj1.username compare:obj2.username];
    }];

    if (self.showProfileInfo) {
        if (self.users.count == 0) {
            [items addObject:@(_canLeaveTheGroup ? CMGroupInfoSectionUserProfileWithLeaveGroupButton : CMGroupInfoSectionUserProfile)];
            [self.output hideInviteButton];
        } else {
            [items addObject:@(_canLeaveTheGroup ? CMGroupInfoSectionUserProfileWithInviteButtonLeaveGroupButton : CMGroupInfoSectionUserProfileWithInviteButton)];
            [self.output showInviteButton];
        }
    } else {
        [self.output hideInviteButton];
    }

    if (self.users.count == 0) {
        [items addObject:@([CMStore instance].isOnboardingSkipped ? CMGroupInfoInviteFriendsSectionWithContinueTutorialButton : CMGroupInfoInviteFriendsSection)];
    } else {
        [items addObject:@(CMGroupInfoFriendsHeaderSection)];
        [items addObjectsFromArray:self.users];
    }

    TLIndexPathDataModel *updatedModel = [[TLIndexPathDataModel alloc] initWithItems:items];
    [self updateDataModel:updatedModel];
}

- (void)setupView {
    [self reloadData];
}

- (void)setItemCollectionDisplayNode:(ASCollectionNode *)node {
    self.collectionNode = node;
    [self reloadData];
}

- (void)inviteFriendsGroupInfoNodeDidTapLearnMoreButton:(CMInviteFriendsGroupInfoNode *)node {
    NSURL *infoURL = [[NSURL alloc] initWithString:@"http://camment.tv"];
    [[CMOpenURLHelper new] openURL:infoURL];
}

- (void)handleDidTapInviteFriendsButton {
    [[[CMStore instance] inviteFriendsActionSubject] sendNext:@YES];
}

- (void)handleDidTapContinueTutorialButton {
    [[[CMStore instance] startTutorial] sendNext:@YES];
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
            case CMGroupInfoSectionUserProfileWithLeaveGroupButton:
            case CMGroupInfoSectionUserProfileWithInviteButtonLeaveGroupButton:
            case CMGroupInfoSectionUserProfile:
            case CMGroupInfoSectionUserProfileWithInviteButton: {
                CMProfileViewNodeContext *context = [CMProfileViewNodeContext new];
                context.shouldDisplayLeaveGroupButton = self.canLeaveTheGroup;
                __weak typeof(self) weakSelf = self;
                context.onLeaveGroupBlock = ^{
                    [weakSelf leaveTheGroup];
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
            case CMGroupInfoFriendsHeaderSection: {
                cellNodeBlock = ^ASCellNode *() {
                    return [CMPeopleJoinedHeaderCell new];
                };
                break;
            }
        }
    } else {
        CMUser *user = model;
        BOOL showDeleteUserButton = self.haveUserDeletionPermissions;
        NSString *onlineStatus = user.onlineStatus;
        if ([user.cognitoUserId isEqualToString:self.groupHost]) {
            onlineStatus = CMUserOnlineStatus.Broadcasting;
        }

        user = [[[CMUserBuilder userFromExistingUser:user] withOnlineStatus:onlineStatus] build];
        __weak typeof(self) delegate = self;
        cellNodeBlock = ^ASCellNode *() {
            CMGroupInfoUserCell *cell = [[CMGroupInfoUserCell alloc] initWithUser:user
                                                       showBlockUnblockUserButton:showDeleteUserButton];
            cell.delegate = delegate;
            return cell;
        };
    }

    return cellNodeBlock;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)useCell:(CMGroupInfoUserCell *)cell didHandleBlockUserAction:(CMUser *)userToBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:CMLocalized(@"alert.confirm_block_user.title")
                                                                             message:[NSString stringWithFormat:CMLocalized(@"alert.confirm_block_user.text"), userToBlock.username]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Yes") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [CMStore instance].activeGroupUsers = [[CMStore instance].activeGroupUsers.rac_sequence map:^CMUser *(CMUser *user) {
            if ([user.cognitoUserId isEqualToString:userToBlock.cognitoUserId]) {
                CMUser *blockedUser = [[[CMUserBuilder userFromExistingUser:userToBlock] withBlockStatus:CMUserBlockStatus.Blocked] build];
                return blockedUser;
            }
            return user;
        }].array;
        [self reloadData];
        [self.interactor blockUser:userToBlock
                             group:[CMStore instance].activeGroup];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"No") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];

    [self.output presentViewController:alertController];
}

- (void)useCell:(CMGroupInfoUserCell *)cell didHandleUnblockUserAction:(CMUser *)userToUnblock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:CMLocalized(@"alert.confirm_unblock_user.title")
                                                                             message:[NSString stringWithFormat:CMLocalized(@"alert.confirm_unblock_user.text"), userToUnblock.username]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Yes") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [CMStore instance].activeGroupUsers = [[CMStore instance].activeGroupUsers.rac_sequence map:^CMUser *(CMUser *user) {
            if ([user.cognitoUserId isEqualToString:userToUnblock.cognitoUserId]) {
                CMUser *blockedUser = [[[CMUserBuilder userFromExistingUser:userToUnblock] withBlockStatus:CMUserBlockStatus.Active] build];
                return blockedUser;
            }
            return user;
        }].array;
        [self reloadData];
        [self.interactor unblockUser:userToUnblock
                               group:[CMStore instance].activeGroup];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"No") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];

    [self.output presentViewController:alertController];
}

- (void)updateDataModel:(TLIndexPathDataModel *)dataModel {
    TLIndexPathDataModel *oldDataModel = self.dataModel;
    self.dataModel = dataModel;

    TLIndexPathUpdates *updates = [[TLIndexPathUpdates alloc] initWithOldDataModel:oldDataModel
                                                                  updatedDataModel:self.dataModel];

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
    }                             completion:^(BOOL finished) {

    }];
}

- (void)groupInfoInteractor:(id <CMGroupInfoInteractorInput>)interactor
 didFailToFetchUsersInGroup:(NSError *)group
{
    DDLogError(@"failed to fetch users in group %@",group);
}

- (void)groupInfoInteractor:(id <CMGroupInfoInteractorInput>)interactor
              didFetchUsers:(NSArray<CMUser *> *)users inGroup:(NSString *)group
{}

- (void)groupInfoInteractor:(id <CMGroupInfoInteractorInput>)interactor
        didFailToDeleteUser:(CMUser *)user
                  fromGroup:(CMUsersGroup *)group
                      error:(NSError *)error
{
    if (![group.uuid isEqualToString:[CMStore instance].activeGroup.uuid]) {
        return;
    }

    [[CMStore instance] refetchUsersInActiveGroup];

    CMErrorWireframe *errorWireframe = [CMErrorWireframe new];
    UIViewController *errorViewController = [errorWireframe viewControllerDisplayingError:error];
    if (!errorViewController) {
        [errorWireframe presentErrorViewWithError:error
                                 inViewController:nil];
    } else {
        [[CammentSDK instance].sdkUIDelegate cammentSDKWantsPresentViewController:errorViewController];
    }

    DDLogError(@"failed to delete user %@ from group %@, error %@",user, group, error);
}

- (void)groupInfoInteractor:(id <CMGroupInfoInteractorInput>)interactor
              didDeleteUser:(CMUser *)user
                  fromGroup:(CMUsersGroup *)group {}

- (void)groupInfoInteractor:(CMGroupInfoInteractor *)interactor
         didFailToBlockUser:(CMUser *)failedUser
                      group:(CMUsersGroup *)group
                      error:(NSError *)error
{
    if (![group.uuid isEqualToString:[CMStore instance].activeGroup.uuid]) {
        return;
    }

    [CMStore instance].activeGroupUsers = [[CMStore instance].activeGroupUsers.rac_sequence map:^CMUser *(CMUser *user) {
        if ([user.cognitoUserId isEqualToString:failedUser.cognitoUserId]) {
            CMUser *updatedUser = [[[CMUserBuilder userFromExistingUser:user] withBlockStatus:CMUserBlockStatus.Active] build];
            return updatedUser;
        }
        return user;
    }].array;
    [self reloadData];
    [[CMStore instance] refetchUsersInActiveGroup];

    CMErrorWireframe *errorWireframe = [CMErrorWireframe new];
    UIViewController *errorViewController = [errorWireframe viewControllerDisplayingError:error];
    if (!errorViewController) {
        [errorWireframe presentErrorViewWithError:error
                                 inViewController:nil];
    } else {
        [[CammentSDK instance].sdkUIDelegate cammentSDKWantsPresentViewController:errorViewController];
    }

    DDLogError(@"failed to block failedUser %@ in group %@, error %@",failedUser, group, error);
}

- (void)groupInfoInteractor:(CMGroupInfoInteractor *)interactor
               didBlockUser:(CMUser *)user
                      group:(CMUsersGroup *)group {}

- (void)groupInfoInteractor:(CMGroupInfoInteractor *)interactor
       didFailToUnblockUser:(CMUser *)failedUser
                      group:(CMUsersGroup *)group
                      error:(NSError *)error
{
    if (![group.uuid isEqualToString:[CMStore instance].activeGroup.uuid]) {
        return;
    }

    [CMStore instance].activeGroupUsers = [[CMStore instance].activeGroupUsers.rac_sequence map:^CMUser *(CMUser *user) {
        if ([user.cognitoUserId isEqualToString:failedUser.cognitoUserId]) {
            CMUser *updatedUser = [[[CMUserBuilder userFromExistingUser:user] withBlockStatus:CMUserBlockStatus.Blocked] build];
            return updatedUser;
        }
        return user;
    }].array;
    [self reloadData];
    [[CMStore instance] refetchUsersInActiveGroup];

    CMErrorWireframe *errorWireframe = [CMErrorWireframe new];
    UIViewController *errorViewController = [errorWireframe viewControllerDisplayingError:error];
    if (!errorViewController) {
        [errorWireframe presentErrorViewWithError:error
                                 inViewController:nil];
    } else {
        [[CammentSDK instance].sdkUIDelegate cammentSDKWantsPresentViewController:errorViewController];
    }

    DDLogError(@"failed to unblock failedUser %@ in group %@, error %@", failedUser, group, error);
}

- (void)groupInfoInteractor:(CMGroupInfoInteractor *)interactor
             didUnblockUser:(CMUser *)user
                      group:(CMUsersGroup *)group {}

- (void)leaveTheGroup {
    __weak typeof(self) weakSelf = self;
    [self.output presentConfirmationDialogToLeaveTheGroup:^{
        CMAuthStatusChangedEventContext *authStatusChangedEventContext = [CMStore instance].authentificationStatusSubject.first;
        [weakSelf.interactor deleteUser:authStatusChangedEventContext.user
                             fromGroup:[CMStore instance].activeGroup];
    }];
}

- (void)groupInfoDidPressInviteButton {
    [self handleDidTapInviteFriendsButton];
}

@end
