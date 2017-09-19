//
//  CMGroupsListCMGroupsListInteractor.h
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMGroupsListInteractorInput.h"
#import "CMGroupsListInteractorOutput.h"

@interface CMGroupsListInteractor : NSObject<CMGroupsListInteractorInput>

@property (nonatomic, weak) id<CMGroupsListInteractorOutput> output;

@end