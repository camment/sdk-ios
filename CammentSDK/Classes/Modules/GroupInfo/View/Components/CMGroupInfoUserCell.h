//
// Created by Alexander Fedosov on 13.10.2017.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMUser, CMGroupInfoUserCell;

@protocol CMGroupInfoUserCellDelegate<NSObject>

- (void)useCell:(CMGroupInfoUserCell *)cell didHandleDeleteUserAction:(CMUser *)user;

@end

@interface CMGroupInfoUserCell : ASCellNode

@property (nonatomic, weak) id<CMGroupInfoUserCellDelegate> delegate;

- (instancetype)initWithUser:(CMUser *)user showDeleteUserButton:(BOOL)showDeleteUserButton;

@end