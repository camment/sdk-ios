//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "CammentSDK.h"
#import "CMStore.h"
#import "CMAnalytics.h"
#import "CMCognitoAuthService.h"
#import "CMCognitoFacebookAuthProvider.h"
#import "CMCamment.h"
#import "CMServerListenerCredentials.h"
#import "CMServerListener.h"
#import "CMCammentFacebookIdentity.h"


@interface CammentSDK ()
@property(nonatomic, strong) id authService;
@end

@implementation CammentSDK

+ (CammentSDK *)instance {
    static CammentSDK *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)configureWithApiKey:(NSString *)apiKey {
    [self configure];
    [self launch];
}

- (void)connectUserWithIdentity:(CMCammentIdentity *)identity {

    if ([identity isKindOfClass:[CMCammentFacebookIdentity class]]) {
        CMCammentFacebookIdentity *cammentFacebookIdentity = (CMCammentFacebookIdentity *) identity;
        [FBSDKAccessToken setCurrentAccessToken:cammentFacebookIdentity.fbsdkAccessToken];
        [[self.authService signIn] subscribeCompleted:^{

        }];
    }
}


- (void)launch {
    [[CMStore instance] setIsSignedIn:[self.authService isSignedIn]];
    [[RACObserve([CMStore instance], isSignedIn) deliverOnMainThread] subscribeNext:^(NSNumber *isSignedIn) {
        if (isSignedIn.boolValue) {
            [self configureIoTListener];
        } else {
        }
    }];
}

- (void)configure {
    [[CMAnalytics instance] configureAWSMobileAnalytics];

    self.authService = [[CMCognitoAuthService alloc] initWithProvider:[CMCognitoFacebookAuthProvider new]];
}

- (void)configureIoTListener {
    CMServerListenerCredentials *credentials =
            [[CMServerListenerCredentials alloc] initWithClientId:[NSUUID new].UUIDString
                                                          keyFile:@"awsiot-identity"
                                                       passPhrase:@"8uT$BwY+x=DF,M"
                                                    certificateId:nil];

    CMServerListener* listener = [CMServerListener instanceWithCredentials:credentials];
    [listener connect];
    [listener.messageSubject subscribeNext:^(CMServerMessage *x) {

    }];
}
@end
