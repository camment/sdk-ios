//
//  CMGroupManagementCMGroupManagementInteractor.h
//  Pods
//
//  Created by Alexander Fedosov on 05/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMGroupManagementInteractorInput.h"
#import "CMGroupManagementInteractorOutput.h"

@interface CMGroupManagementInteractor : NSObject<CMGroupManagementInteractorInput>

@property (nonatomic, weak) id<CMGroupManagementInteractorOutput> output;

@end