//
// Created by Alexander Fedosov on 20.09.17.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMUsersGroup;


@interface CMGroupCellNode : ASCellNode

@property(nonatomic, strong, readonly) CMUsersGroup *group;

- (instancetype)initWithGroup:(CMUsersGroup *)group;
@end