//
//  CMGroupInfoCMGroupInfoPresenter.h
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMGroupInfoPresenterInput.h"
#import "CMGroupInfoPresenterOutput.h"
#import "CMGroupInfoInteractorInput.h"
#import "CMGroupInfoInteractorOutput.h"

@class CMGroupInfoWireframe;

@interface CMGroupInfoPresenter : NSObject<CMGroupInfoPresenterInput, CMGroupInfoInteractorOutput>

@property (nonatomic, weak) id<CMGroupInfoPresenterOutput> output;
@property (nonatomic) id<CMGroupInfoInteractorInput> interactor;
@property (nonatomic) CMGroupInfoWireframe *wireframe;

@end