//
// Created by Alexander Fedosov on 13.10.2017.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMUser, CMGroupInfoUserCell;

@protocol CMGroupInfoUserCellDelegate<NSObject>

- (void)useCell:(CMGroupInfoUserCell *)cell didHandleBlockUserAction:(CMUser *)user;
- (void)useCell:(CMGroupInfoUserCell *)cell didHandleUnblockUserAction:(CMUser *)user;

@end

@interface CMGroupInfoUserCell : ASCellNode

@property (nonatomic, weak) id<CMGroupInfoUserCellDelegate> delegate;

- (instancetype)initWithUser:(CMUser *)user showBlockUnblockUserButton:(BOOL)showDeleteUserButton;

@end