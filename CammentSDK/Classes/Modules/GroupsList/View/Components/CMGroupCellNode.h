//
// Created by Alexander Fedosov on 20.09.17.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMUsersGroup;

@protocol CMGroupsListNodeDelegate<ASCollectionDelegate, ASCollectionDataSource, UICollectionViewDelegateFlowLayout>

- (void)groupListDidHandleRefreshAction:(UIRefreshControl *)refreshControl;

@end

@interface CMGroupCellNode : ASCellNode

@property(nonatomic, strong, readonly) CMUsersGroup *group;
@property (nonatomic, weak) id<CMGroupsListNodeDelegate>delegate;

- (instancetype)initWithGroup:(CMUsersGroup *)group;
@end
