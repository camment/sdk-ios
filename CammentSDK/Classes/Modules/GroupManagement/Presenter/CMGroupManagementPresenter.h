//
//  CMGroupManagementCMGroupManagementPresenter.h
//  Pods
//
//  Created by Alexander Fedosov on 05/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMGroupManagementPresenterInput.h"
#import "CMGroupManagementPresenterOutput.h"
#import "CMGroupManagementInteractorInput.h"
#import "CMGroupManagementInteractorOutput.h"

@class CMGroupManagementWireframe;

@interface CMGroupManagementPresenter : NSObject<CMGroupManagementPresenterInput, CMGroupManagementInteractorOutput>

@property (nonatomic, weak) id<CMGroupManagementPresenterOutput> output;
@property (nonatomic) id<CMGroupManagementInteractorInput> interactor;
@property (nonatomic) CMGroupManagementWireframe *wireframe;

@end