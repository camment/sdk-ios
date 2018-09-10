//
//  CMGroupsListCMGroupsListInteractorOutput.h
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMGroupsListInteractor;

@protocol CMGroupsListInteractorOutput <NSObject>

- (void)groupListInteractor:(id <CMGroupsListInteractorInput>)interactor didFetchUserGroups:(NSArray *)group;
- (void)groupListInteractor:(id <CMGroupsListInteractorInput>)interactor didFailToFetchUserGroups:(NSError *)error;

@end
