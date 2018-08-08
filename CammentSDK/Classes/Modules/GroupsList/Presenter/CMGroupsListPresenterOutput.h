//
//  CMGroupsListCMGroupsListPresenterOutput.h
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMUsersGroup;

@protocol CMGroupsListPresenterOutput <NSObject>

- (void)hideCreateGroupButton;
- (void)showCreateGroupButton;
- (void)hideLoadingIndicator;

@end

@protocol CMGroupsListPresenterDelegate <NSObject>

- (void)didSelectGroup:(CMUsersGroup *)group;

@end
