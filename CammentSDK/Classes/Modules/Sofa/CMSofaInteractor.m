//
//  CMSofaInteractor.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 29/08/2018.
//

#import "CMSofaInteractor.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"
#import "CMSofaInvitationInteractor.h"

@implementation CMSofaInteractor

- (instancetype)initWithInvitationInteractor:(CMSofaInvitationInteractor *)invitationInteractor output:(id <CMSofaInteractorOutput>)output {
    self = [super init];
    if (self) {
        self.invitationInteractor = invitationInteractor;
        self.output = output;
    }

    return self;
}

+ (instancetype)interactorWithInvitationInteractor:(CMSofaInvitationInteractor *)invitationInteractor output:(id <CMSofaInteractorOutput>)output {
    return [[self alloc] initWithInvitationInteractor:invitationInteractor output:output];
}


- (void)fetchSofaViewForShow:(NSString *)uuid {
    [[[CMAPIDevcammentClient defaultAPIClient] sofaShowUuidGet:uuid] continueWithBlock:^id _Nullable(AWSTask * _Nonnull task) {
        CMAPISofa *result = task.result;
        
        if (!task.error) {
            if ([self.output respondsToSelector:@selector(sofaViewDidFetchedContent:)]) {
                [self.output sofaViewDidFetchedContent:result];
            }
        } else {
            if ([self.output respondsToSelector:@selector(sofaViewDidFailedFetching:)]) {
                [self.output sofaViewDidFailedFetching:task.error];
            }
        }
        
        return nil;
    }];
}

@end
