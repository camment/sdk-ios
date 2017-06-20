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
#import "CMCammentAnonymousIdentity.h"
#import "CMPresentationBuilder.h"
#import "CMWoltPresentationBuilder.h"
#import "CMPresentationUtility.h"

#import <FBTweak.h>
#import <FBTweakStore.h>
#import <FBTweakCollection.h>
#import <FBTweakCategory.h>

@interface CammentSDK ()
@property(nonatomic, strong) CMCognitoAuthService* authService;
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
    
    FBTweakCollection *webSettingCollection = [presentationCategory tweakCollectionWithName:@"Web settings"];
    if (!webSettingCollection) {
        webSettingCollection = [[FBTweakCollection alloc] initWithName:@"Web settings"];
        [presentationCategory addTweakCollection: webSettingCollection];
    }
    
    NSString *tweakName = @"Web page url";
    FBTweak *cammentDelayTweak = [webSettingCollection tweakWithIdentifier:tweakName];
    if (!cammentDelayTweak) {
        cammentDelayTweak = [[FBTweak alloc] initWithIdentifier:tweakName];
        cammentDelayTweak.defaultValue = @"http://aftonbladet.se";
        cammentDelayTweak.currentValue = @"http://aftonbladet.se";
        cammentDelayTweak.name = tweakName;
        [webSettingCollection addTweak:cammentDelayTweak];
    }
    
    FBTweakCategory *settingsCategory = [store tweakCategoryWithName:@"Settings"];
    if (!settingsCategory) {
        settingsCategory = [[FBTweakCategory alloc] initWithName:@"Settings"];
        [store addTweakCategory:settingsCategory];
    }
    
    FBTweakCollection *videoSettingsCollection = [presentationCategory tweakCollectionWithName:@"Video player settings"];
    if (!videoSettingsCollection) {
        videoSettingsCollection = [[FBTweakCollection alloc] initWithName:@"Video player settings"];
        [settingsCategory addTweakCollection: videoSettingsCollection];
    }
    
    FBTweak *volumeTweak = [presentationsCollection tweakWithIdentifier:@"Volume"];
    if (!volumeTweak) {
        volumeTweak = [[FBTweak alloc] initWithIdentifier:@"Volume"];
        volumeTweak.minimumValue = @.0f;
        volumeTweak.stepValue = @10.0f;
        volumeTweak.maximumValue = @100.0f;
        volumeTweak.defaultValue = @30.0f;
        volumeTweak.name = @"Volume (%)";
        [videoSettingsCollection addTweak:volumeTweak];
    }
}

- (void)configureWithApiKey:(NSString *)apiKey {
    [self configure];
    [self launch];
    [self connectUserWithIdentity:[CMCammentAnonymousIdentity new]
                          success:nil
                            error:nil];
}

- (void)connectUserWithIdentity:(CMCammentIdentity *)identity
                        success:(void (^ _Nullable)())successBlock
                          error:(void (^ _Nullable)(NSError *error))errorBlock {

    if ([identity isKindOfClass:[CMCammentFacebookIdentity class]]) {
        [self.authService configureWithProvider:[CMCognitoFacebookAuthProvider new]];
        CMCammentFacebookIdentity *cammentFacebookIdentity = (CMCammentFacebookIdentity *) identity;
        [FBSDKAccessToken setCurrentAccessToken:cammentFacebookIdentity.fbsdkAccessToken];
        [[self.authService signIn] subscribeError:^(NSError *error) {
            [[CMStore instance] setIsSignedIn:NO];
            if (errorBlock) {
                errorBlock(error);
            }
        } completed:^{
            [[CMStore instance] setIsSignedIn:YES];
            if (successBlock) { successBlock(); }
        }];
    } if ([identity isKindOfClass:[CMCammentAnonymousIdentity class]]) {
        [[CMStore instance] setIsSignedIn:YES];
        if (successBlock) { successBlock(); }
    }  else {
        if (errorBlock) {
            errorBlock([NSError
                    errorWithDomain:@"tv.camment.ios"
                               code:0
                           userInfo:@{}]);
        }
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
    
    self.authService = [[CMCognitoAuthService alloc] init];
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
