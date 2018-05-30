//
//  CMGroupInfoCMGroupInfoPresenterOutput.h
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMGroupInfoPresenterOutput <NSObject>

- (void)presentViewController:(UIViewController *)viewController;

- (void)presentConfirmationDialogToLeaveTheGroup:(void (^)())onConfirmed;

- (void)closeGroupsListView;

- (void)openGroupsListView;
@end