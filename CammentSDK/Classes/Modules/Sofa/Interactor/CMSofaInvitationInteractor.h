//
// Created by Alexander Fedosov on 30/08/2018.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>
#import "CMInvitationInteractorOutput.h"

static NSString *const CMSofaInteractorErrorDomain = @"sofa.camment.tv";
static const int CMSofaInteractorLoginFlowCancelled = 2265;
@class CMUserSessionController;
@class CMStore;
@protocol CMInvitationInteractorInput;


@interface CMSofaInvitationInteractor : NSObject<CMInvitationInteractorOutput>

@property (nonatomic, strong) CMUserSessionController *userSessionController;
@property (nonatomic, strong) id <CMInvitationInteractorInput> invitationInteractor;
@property (nonatomic, strong) CMStore *store;

- (instancetype)initWithUserSessionController:(CMUserSessionController *)userSessionController invitationInteractor:(id <CMInvitationInteractorInput>)invitationInteractor store:(CMStore *)store;

- (BFTask *)inviteFriends:(NSString *)showUUID;

@end