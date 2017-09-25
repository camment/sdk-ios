//
//  CMGroupsListCMGroupsListInteractorOutput.h
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMGroupsListInteractorOutput <NSObject>

- (void)didFetchUserGroups:(NSArray *)groups;
- (void)didFailToFetchUserGroups:(NSError *)error;

@end