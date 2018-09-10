//
// Created by Alexander Fedosov on 13.10.2017.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMUser, CMGroupInfoUserCell;
@class CMUserCellViewModel;

@protocol CMGroupInfoUserCellDelegate<NSObject>

- (void)useCell:(CMGroupInfoUserCell *)cell didHandleBlockUserAction:(CMUserCellViewModel *)user;
- (void)useCell:(CMGroupInfoUserCell *)cell didHandleUnblockUserAction:(CMUserCellViewModel *)user;

@end

@interface CMGroupInfoUserCell : ASCellNode

@property (nonatomic, weak) id<CMGroupInfoUserCellDelegate> delegate;

- (id)initWithCellViewModel:(CMUserCellViewModel *)model;

@end