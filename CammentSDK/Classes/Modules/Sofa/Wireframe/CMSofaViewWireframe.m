//
// Created by Alexander Fedosov on 30/08/2018.
//

#import "CMSofaViewWireframe.h"
#import "CMSofaView.h"
#import "CMSofaInvitationInteractor.h"
#import "CMStore.h"
#import "CMUserSessionController.h"
#import "CMInvitationInteractor.h"
#import "CMSofaInteractor.h"

@implementation CMSofaViewWireframe {

}
- (CMSofaView *)sofaView {

    CMInvitationInteractor *cmInvitationInteractor = [[CMInvitationInteractor alloc] init];
    CMSofaInvitationInteractor *invitationInteractor = [[CMSofaInvitationInteractor alloc]
            initWithUserSessionController:[CMUserSessionController instance]
                     invitationInteractor:cmInvitationInteractor
                                    store:[CMStore new]];
    CMSofaInteractor *sofaInteractor = [CMSofaInteractor new];
    cmInvitationInteractor.output = invitationInteractor;
    CMSofaView *view = [CMSofaView new];
    view.invitationInteractor = invitationInteractor;

    return view;
}

@end