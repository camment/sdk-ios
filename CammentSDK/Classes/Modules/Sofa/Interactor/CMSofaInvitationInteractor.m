//
// Created by Alexander Fedosov on 30/08/2018.
//

#import "CMSofaInvitationInteractor.h"
#import "CMUserSessionController.h"
#import "CMStore.h"
#import "CMInvitationInteractorInput.h"
#import "CMAnalytics.h"
#import "CMShowMetadata.h"
#import <AWSCore/AWSCore.h>

@interface CMSofaInvitationInteractor ()

@property(nonatomic, strong) BFTaskCompletionSource *invitationTaskCompletionSource;

@end

@implementation CMSofaInvitationInteractor {

}

- (instancetype)initWithUserSessionController:(CMUserSessionController *)userSessionController
                         invitationInteractor:(id <CMInvitationInteractorInput>)invitationInteractor
                                        store:(CMStore *)store
{
    self = [super init];
    if (self) {
        self.userSessionController = userSessionController;
        self.invitationInteractor = invitationInteractor;
        self.store = store;
    }

    return self;
}

- (BFTask *)inviteFriends {

    if (!self.invitationTaskCompletionSource
            || self.invitationTaskCompletionSource.task.cancelled
            || self.invitationTaskCompletionSource.task.completed
            || self.invitationTaskCompletionSource.task.faulted) {
        self.invitationTaskCompletionSource = [BFTaskCompletionSource new];
    }

    if (self.userSessionController.userAuthentificationState == CMCammentUserAuthentificatedAsKnownUser) {
        [self getInvitationDeeplink];
    } else {
        [[self.userSessionController refreshSession:YES]
                continueWithExecutor:[AWSExecutor mainThreadExecutor]
                           withBlock:^id(AWSTask<CMAuthStatusChangedEventContext *> *task) {
                               if (task.error) {
                                   [self.invitationTaskCompletionSource setError:task.error];
                               } else if (task.result.state != CMCammentUserAuthentificatedAsKnownUser) {
                                   [self.invitationTaskCompletionSource setError:[NSError errorWithDomain:CMSofaInteractorErrorDomain
                                                                                                     code:CMSofaInteractorLoginFlowCancelled
                                                                                                 userInfo:@{}]];
                               } else {
                                   [self inviteFriends];
                               }
                               return nil;
                           }];
    }

    [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventInvite];
    return self.invitationTaskCompletionSource.task;
}

- (void)getInvitationDeeplink {
    [self.invitationInteractor getDeeplink:[CMStore instance].activeGroup
                                  showUuid:[CMStore instance].currentShowMetadata.uuid];
}

- (void)didInviteUsersToTheGroup:(CMUsersGroup *)group usingDeeplink:(BOOL)usedDeeplink {
    if (usedDeeplink) {
        [self.invitationTaskCompletionSource setResult:group.invitationLink];
    }

    [[CMStore instance] setActiveGroup:group];
}

- (void)didFailToInviteUsersWithError:(NSError *)error {
    [self.invitationTaskCompletionSource setError:error];
}

- (void)didFailToGetInvitationLink:(NSError *)error {
    [self.invitationTaskCompletionSource setError:error];
}

@end