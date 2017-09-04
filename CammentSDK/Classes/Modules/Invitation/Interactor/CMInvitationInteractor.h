//
//  CMInvitationCMInvitationInteractor.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 26/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMInvitationInteractorInput.h"
#import "CMInvitationInteractorOutput.h"

@interface CMInvitationInteractor : NSObject<CMInvitationInteractorInput>

@property (nonatomic, weak) id<CMInvitationInteractorOutput> output;

@end