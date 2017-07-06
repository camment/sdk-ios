//
//  CMInvitationCMInvitationNode.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 26/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>


@protocol CMInvitationListDelegate<ASTableDelegate, ASTableDataSource>
- (void)setItemListDisplayNode:(ASTableNode *)node;
@end

@interface CMInvitationNode: ASDisplayNode

@property (nonatomic, strong) ASTableNode *tableNode;

- (void)setInvitationListDelegate:(id<CMInvitationListDelegate>)delegate;

@end
