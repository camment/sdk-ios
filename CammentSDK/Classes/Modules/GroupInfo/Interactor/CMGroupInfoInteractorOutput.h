//
//  CMGroupInfoCMGroupInfoInteractorOutput.h
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMUser;
@class CMUsersGroup;
@class CMGroupInfoInteractor;

@protocol CMGroupInfoInteractorOutput <NSObject>

- (void)groupInfoInteractor:(id <CMGroupInfoInteractorInput>)interactor didFailToFetchUsersInGroup:(NSError *)group;

- (void)groupInfoInteractor:(id <CMGroupInfoInteractorInput>)interactor didFetchUsers:(NSArray<CMUser *> *)users inGroup:(NSString *)group;

- (void)groupInfoInteractor:(id <CMGroupInfoInteractorInput>)interactor didFailToDeleteUser:(CMUser *)user fromGroup:(CMUsersGroup *)group error:(NSError *)error;

- (void)groupInfoInteractor:(id <CMGroupInfoInteractorInput>)interactor didDeleteUser:(CMUser *)user fromGroup:(CMUsersGroup *)group;

- (void)groupInfoInteractor:(CMGroupInfoInteractor *)interactor didFailToBlockUser:(CMUser *)user group:(CMUsersGroup *)group error:(NSError *)error;

- (void)groupInfoInteractor:(CMGroupInfoInteractor *)interactor didBlockUser:(CMUser *)user group:(CMUsersGroup *)group;

- (void)groupInfoInteractor:(CMGroupInfoInteractor *)interactor didFailToUnblockUser:(CMUser *)user group:(CMUsersGroup *)group error:(NSError *)error;

- (void)groupInfoInteractor:(CMGroupInfoInteractor *)interactor didUnblockUser:(CMUser *)user group:(CMUsersGroup *)group;
@end
