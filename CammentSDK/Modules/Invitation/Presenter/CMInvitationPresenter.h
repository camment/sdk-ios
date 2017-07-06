//
//  CMInvitationCMInvitationPresenter.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 26/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMInvitationPresenterInput.h"
#import "CMInvitationPresenterOutput.h"
#import "CMInvitationInteractorInput.h"
#import "CMInvitationInteractorOutput.h"
#import "CMFBFetchFrinedsInteractorInput.h"
#import "CMLoadingHUD.h"

@class CMInvitationWireframe;

@interface CMInvitationPresenter : NSObject<CMInvitationPresenterInput, CMInvitationInteractorOutput>

@property (nonatomic, weak) id<CMInvitationPresenterOutput, CMLoadingHUD> output;
@property (nonatomic) id<CMInvitationInteractorInput> interactor;
@property (nonatomic) id<CMFBFetchFrinedsInteractorInput> fbFetchFriendsInteractor;
@property (nonatomic) CMInvitationWireframe *wireframe;

@end