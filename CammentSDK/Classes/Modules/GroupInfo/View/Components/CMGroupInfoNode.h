//
//  CMGroupInfoCMGroupInfoNode.h
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMInviteFriendsGroupInfoNode.h"

@protocol CMGroupInfoNodeDelegate<CMInviteFriendsGroupInfoNodeDelegate>
@end

@interface CMGroupInfoNode: ASDisplayNode

@property(nonatomic, weak) id<CMGroupInfoNodeDelegate>delegate;

@end
