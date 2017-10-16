//
// Created by Alexander Fedosov on 13.10.2017.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMUser;

@interface CMGroupInfoUserCell : ASCellNode

- (instancetype)initWithUser:(CMUser *)user;

@end