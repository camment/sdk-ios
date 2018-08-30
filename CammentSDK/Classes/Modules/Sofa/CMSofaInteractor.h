//
//  CMSofaInteractor.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 29/08/2018.
//

#import <Foundation/Foundation.h>
#import "CMAPISofa.h"

@class CMSofaInvitationInteractor;

@protocol CMSofaInteractorOutput<NSObject>

- (void)sofaViewDidFetchedContent:(CMAPISofa *)sofa;
- (void)sofaViewDidFailedFetching:(NSError *)error;

@end


@interface CMSofaInteractor : NSObject

@property (nonatomic, strong) CMSofaInvitationInteractor * invitationInteractor;
@property (nonatomic, weak) id<CMSofaInteractorOutput> output;

- (instancetype)initWithInvitationInteractor:(CMSofaInvitationInteractor *)invitationInteractor output:(id <CMSofaInteractorOutput>)output;

+ (instancetype)interactorWithInvitationInteractor:(CMSofaInvitationInteractor *)invitationInteractor output:(id <CMSofaInteractorOutput>)output;

- (void)fetchSofaViewForShow:(NSString *)uuid;

@end
