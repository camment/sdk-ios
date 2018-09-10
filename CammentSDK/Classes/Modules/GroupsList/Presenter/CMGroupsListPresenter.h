//
//  CMGroupsListCMGroupsListPresenter.h
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMGroupsListPresenterInput.h"
#import "CMGroupsListPresenterOutput.h"
#import "CMGroupsListInteractorInput.h"
#import "CMGroupsListInteractorOutput.h"
#import "CMGroupInfoNode.h"

@class CMGroupsListWireframe;

@interface CMGroupsListPresenter : NSObject<CMGroupsListPresenterInput, CMGroupsListInteractorOutput, CMGroupInfoNodeDelegate>

@property (nonatomic, weak) id<CMGroupsListPresenterOutput> output;
@property (nonatomic, weak) id<CMGroupsListPresenterDelegate> delegate;
@property (nonatomic) id<CMGroupsListInteractorInput> interactor;
@property (nonatomic) CMGroupsListWireframe *wireframe;

@end
