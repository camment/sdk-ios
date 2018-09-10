//
//  CMGroupsListCMGroupsListPresenterInput.h
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//


#import <Foundation/Foundation.h>

@class CMUsersGroup;

@protocol CMGroupsListPresenterInput <NSObject>

- (void)setupView;
- (void)reloadGroupList;

@end
