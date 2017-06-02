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
#import "CMPresentationBuilder.h"
#import "CMWoltPresentationBuilder.h"
#import "CMPresentationUtility.h"

#import <FBTweak.h>
#import <FBTweakStore.h>
#import <FBTweakCollection.h>
#import <FBTweakCategory.h>

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

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupTweaks];
    }
    
    return self;
}

- (void)setupTweaks {
    FBTweakStore *store = [FBTweakStore sharedInstance];
    
    FBTweakCategory *presentationCategory = [store tweakCategoryWithName:@"Predefined stuff"];
    if (!presentationCategory) {
        presentationCategory = [[FBTweakCategory alloc] initWithName:@"Predefined stuff"];
        [store addTweakCategory:presentationCategory];
    }
    
    FBTweakCollection *presentationsCollection = [presentationCategory tweakCollectionWithName:@"Demo"];
    if (!presentationsCollection) {
        presentationsCollection = [[FBTweakCollection alloc] initWithName:@"Demo"];
        [presentationCategory addTweakCollection: presentationsCollection];
    }

    NSArray<id<CMPresentationBuilder>> *presentations = [CMPresentationUtility activePresentations];

    FBTweak *showTweak = [presentationsCollection tweakWithIdentifier:@"Scenario"];
    if (!showTweak) {
        showTweak = [[FBTweak alloc] initWithIdentifier:@"Scenario"];
        showTweak.possibleValues = [@[@"None"] arrayByAddingObjectsFromArray:[presentations.rac_sequence map:^id(id <CMPresentationBuilder> value) {
            return [value presentationName];
        }].array];
        showTweak.defaultValue = @"None";
        showTweak.name = @"Choose demo scenario";
        [presentationsCollection addTweak:showTweak];
    }

    for (id <CMPresentationBuilder> presentation in presentations) {
        [presentation configureTweaks:presentationCategory];
    }
}

- (void)configureWithApiKey:(NSString *)apiKey {
    [self configure];
    [self launch];
}

- (RACSignal *)connectUserWithIdentity:(CMCammentIdentity *)identity {

    return [RACSubject createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {

        if ([identity isKindOfClass:[CMCammentFacebookIdentity class]]) {
            CMCammentFacebookIdentity *cammentFacebookIdentity = (CMCammentFacebookIdentity *) identity;
            [FBSDKAccessToken setCurrentAccessToken:cammentFacebookIdentity.fbsdkAccessToken];
            [[self.authService signIn] subscribeError:^(NSError *error) {
                [[CMStore instance] setIsSignedIn:NO];
                [subscriber sendError:error];
            } completed:^{
                [[CMStore instance] setIsSignedIn:YES];
                [subscriber sendCompleted];
            }];
        } else {
            [subscriber sendError:[NSError
                    errorWithDomain:@"tv.camment.ios"
                               code:0
                           userInfo:@{}]];
        }

        return nil;
    }];
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
