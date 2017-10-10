//
// Created by Alexander Fedosov on 10.10.2017.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@protocol CMShowCellNodeDelegate;


@interface CMShowListHeaderCell : ASCellNode

@property (nonatomic, weak) id<CMShowCellNodeDelegate> delegate;

@end