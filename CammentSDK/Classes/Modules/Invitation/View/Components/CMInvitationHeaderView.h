//
// Created by Alexander Fedosov on 08.08.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CMInvitationListSection.h"


@interface CMInvitationHeaderView : UITableViewHeaderFooterView

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (void)configure:(CMInvitationListSection)section;

@end
