//
//  CMGroupInfoCMGroupInfoInteractorOutput.h
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMUser;

@protocol CMGroupInfoInteractorOutput <NSObject>

- (void)groupInfoInteractor:(id <CMGroupInfoInteractorInput>)interactor didFailToFetchUsersInGroup:(NSError *)group;

- (void)groupInfoInteractor:(id <CMGroupInfoInteractorInput>)interactor didFetchUsers:(NSArray<CMUser *> *)users inGroup:(NSString *)group;
@end
