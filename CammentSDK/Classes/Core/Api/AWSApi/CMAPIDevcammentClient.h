/*
 Copyright 2010-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License").
 You may not use this file except in compliance with the License.
 A copy of the License is located at

 http://aws.amazon.com/apache2.0

 or in the "license" file accompanying this file. This file is distributed
 on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 express or implied. See the License for the specific language governing
 permissions and limitations under the License.
 */
 

#import <Foundation/Foundation.h>
#import <AWSAPIGateway/AWSAPIGateway.h>

#import "CMAPICamment.h"
#import "CMAPICustomError.h"
#import "CMAPIDeeplink.h"
#import "CMAPIGroupUuidInRequest.h"
#import "CMAPIFacebookFriendList.h"
#import "CMAPIUsergroupList.h"
#import "CMAPIPublicGroupList.h"
#import "CMAPIShowList.h"
#import "CMAPIShow.h"
#import "CMAPISofa.h"
#import "CMAPIUsergroup.h"
#import "CMAPIUsergroupInRequest.h"
#import "CMAPICammentList.h"
#import "CMAPICammentInRequest.h"
#import "CMAPIShowUuid.h"
#import "CMAPIIotInRequest.h"
#import "CMAPIUserinfoList.h"
#import "CMAPIUpdateUserStateInGroupRequest.h"
#import "CMAPIUserinfo.h"
#import "CMAPIOpenIdToken.h"

@class CMAppConfig;


NS_ASSUME_NONNULL_BEGIN

/**
 The service client object.
 */
@interface CMAPIDevcammentClient: AWSAPIGatewayClient

/**
 Returns the singleton service client. If the singleton object does not exist, the SDK instantiates the default service client with `defaultServiceConfiguration` from `[AWSServiceManager defaultServiceManager]`. The reference to this object is maintained by the SDK, and you do not need to retain it manually.

 If you want to enable AWS Signature, set the default service configuration in `- application:didFinishLaunchingWithOptions:`
 
 *Swift*

     func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
         let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "YourIdentityPoolId")
         let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialProvider)
         AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration

         return true
     }

 *Objective-C*

     - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
          AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                          identityPoolId:@"YourIdentityPoolId"];
          AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1
                                                                               credentialsProvider:credentialsProvider];
          [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;

          return YES;
      }

 Then call the following to get the default service client:

 *Swift*

     let serviceClient = CMAPIDevcammentClient.defaultClient()

 *Objective-C*

     CMAPIDevcammentClient *serviceClient = [CMAPIDevcammentClient defaultClient];

 Alternatively, this configuration could also be set in the `info.plist` file of your app under `AWS` dictionary with a configuration dictionary by name `CMAPIDevcammentClient`.

 @return The default service client.
 */
+ (instancetype)defaultClient;

/**
 Creates a service client with the given service configuration and registers it for the key.

 If you want to enable AWS Signature, set the default service configuration in `- application:didFinishLaunchingWithOptions:`

 *Swift*

     func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
         let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "YourIdentityPoolId")
         let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialProvider)
         CMAPIDevcammentClient.registerClientWithConfiguration(configuration, forKey: "USWest2CMAPIDevcammentClient")

         return true
     }

 *Objective-C*

     - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
         AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                         identityPoolId:@"YourIdentityPoolId"];
         AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSWest2
                                                                              credentialsProvider:credentialsProvider];

         [CMAPIDevcammentClient registerClientWithConfiguration:configuration forKey:@"USWest2CMAPIDevcammentClient"];

         return YES;
     }

 Then call the following to get the service client:

 *Swift*

     let serviceClient = CMAPIDevcammentClient(forKey: "USWest2CMAPIDevcammentClient")

 *Objective-C*

     CMAPIDevcammentClient *serviceClient = [CMAPIDevcammentClient clientForKey:@"USWest2CMAPIDevcammentClient"];

 @warning After calling this method, do not modify the configuration object. It may cause unspecified behaviors.

 @param configuration A service configuration object.
 @param key           A string to identify the service client.
 */
+ (void)registerClientWithConfiguration:(AWSServiceConfiguration *)configuration forKey:(NSString *)key appConfig:(CMAppConfig *)appConfig;

/**
 Retrieves the service client associated with the key. You need to call `+ registerClientWithConfiguration:forKey:` before invoking this method or alternatively, set the configuration in your application's `info.plist` file. If `+ registerClientWithConfiguration:forKey:` has not been called in advance or if a configuration is not present in the `info.plist` file of the app, this method returns `nil`.

 For example, set the default service configuration in `- application:didFinishLaunchingWithOptions:`

 *Swift*

     func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
         let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "YourIdentityPoolId")
         let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialProvider)
         CMAPIDevcammentClient.registerClientWithConfiguration(configuration, forKey: "USWest2CMAPIDevcammentClient")

         return true
     }

 *Objective-C*

     - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
         AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                         identityPoolId:@"YourIdentityPoolId"];
         AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSWest2
                                                                              credentialsProvider:credentialsProvider];

         [CMAPIDevcammentClient registerClientWithConfiguration:configuration forKey:@"USWest2CMAPIDevcammentClient"];

         return YES;
     }

 Then call the following to get the service client:

 *Swift*

     let serviceClient = CMAPIDevcammentClient(forKey: "USWest2CMAPIDevcammentClient")

 *Objective-C*

     CMAPIDevcammentClient *serviceClient = [CMAPIDevcammentClient clientForKey:@"USWest2CMAPIDevcammentClient"];

 @param key A string to identify the service client.

 @return An instance of the service client.
 */
+ (instancetype)clientForKey:(NSString *)key;

/**
 Removes the service client associated with the key and release it.
 
 @warning Before calling this method, make sure no method is running on this client.
 
 @param key A string to identify the service client.
 */
+ (void)removeClientForKey:(NSString *)key;

/**
 
 
 
 return type: 
 */
- (AWSTask *)adsGet;

/**
 
 
 @param adUuid 
 
 return type: 
 */
- (AWSTask *)adsAdUuidGet:( NSString *)adUuid;

/**
 
 
 
 return type: 
 */
- (AWSTask *)adsAdUuidConfirmPost;

/**
 
 
 @param cammentUuid 
 
 return type: CMAPICamment *
 */
- (AWSTask *)cammentsCammentUuidGet:( NSString *)cammentUuid;

/**
 
 
 @param cammentUuid 
 
 return type: 
 */
- (AWSTask *)cammentsCammentUuidPost:( NSString *)cammentUuid;

/**
 
 
 @param deeplinkHash 
 @param os 
 
 return type: CMAPIDeeplink *
 */
- (AWSTask *)deferredDeeplinkGet:(nullable NSString *)deeplinkHash os:(nullable NSString *)os;

/**
 
 
 @param body 
 
 return type: 
 */
- (AWSTask *)meActiveGroupPost:( CMAPIGroupUuidInRequest *)body;

/**
 
 
 
 return type: 
 */
- (AWSTask *)meActiveGroupDelete;

/**
 
 
 @param fbAccessToken 
 
 return type: CMAPIFacebookFriendList *
 */
- (AWSTask *)meFbFriendsGet:(nullable NSString *)fbAccessToken;

/**
 
 
 @param showId 
 
 return type: CMAPIUsergroupList *
 */
- (AWSTask *)meGroupsGet:(nullable NSString *)showId;

/**
 
 
 
 return type: 
 */
- (AWSTask *)meUuidPut;

/**
 
 
 
 return type: CMAPIPublicGroupList *
 */
- (AWSTask *)publicgroupsGet;

/**
 
 
 @param passcode 
 
 return type: CMAPIShowList *
 */
- (AWSTask *)showsGet:(nullable NSString *)passcode;

/**
 
 
 @param uuid 
 
 return type: CMAPIShow *
 */
- (AWSTask *)showsUuidGet:( NSString *)uuid;

/**
 
 
 @param showUuid 
 
 return type: CMAPISofa *
 */
- (AWSTask *)sofaShowUuidGet:( NSString *)showUuid;

/**
 
 
 @param body 
 
 return type: CMAPIUsergroup *
 */
- (AWSTask *)usergroupsPost:( CMAPIUsergroupInRequest *)body;

/**
 
 
 @param groupUuid 
 
 return type: CMAPIUsergroup *
 */
- (AWSTask *)usergroupsGroupUuidGet:( NSString *)groupUuid;

/**
 
 
 @param groupUuid 
 @param timeTo 
 @param limit 
 @param timeFrom 
 @param lastKey 
 
 return type: CMAPICammentList *
 */
- (AWSTask *)usergroupsGroupUuidCammentsGet:( NSString *)groupUuid timeTo:(nullable NSString *)timeTo limit:(nullable NSString *)limit timeFrom:(nullable NSString *)timeFrom lastKey:(nullable NSString *)lastKey;

/**
 
 
 @param groupUuid 
 @param body 
 
 return type: 
 */
- (AWSTask *)usergroupsGroupUuidCammentsPost:( NSString *)groupUuid body:( CMAPICammentInRequest *)body;

/**
 
 
 @param cammentUuid 
 @param groupUuid 
 
 return type: 
 */
- (AWSTask *)usergroupsGroupUuidCammentsCammentUuidDelete:( NSString *)cammentUuid groupUuid:( NSString *)groupUuid;

/**
 
 
 @param groupUuid 
 @param body 
 
 return type: CMAPIDeeplink *
 */
- (AWSTask *)usergroupsGroupUuidDeeplinkPost:( NSString *)groupUuid body:( CMAPIShowUuid *)body;

/**
 
 
 @param groupUuid 
 @param body 
 
 return type: 
 */
- (AWSTask *)usergroupsGroupUuidIotPost:( NSString *)groupUuid body:( CMAPIIotInRequest *)body;

/**
 
 
 @param groupUuid 
 
 return type: CMAPIUserinfoList *
 */
- (AWSTask *)usergroupsGroupUuidUsersGet:( NSString *)groupUuid;

/**
 
 
 @param groupUuid 
 @param body 
 
 return type: 
 */
- (AWSTask *)usergroupsGroupUuidUsersPost:( NSString *)groupUuid body:( CMAPIShowUuid *)body;

/**
 
 
 @param userId 
 @param groupUuid 
 @param body 
 
 return type: 
 */
- (AWSTask *)usergroupsGroupUuidUsersUserIdPut:( NSString *)userId groupUuid:( NSString *)groupUuid body:( CMAPIUpdateUserStateInGroupRequest *)body;

/**
 
 
 @param userId 
 @param groupUuid 
 
 return type: 
 */
- (AWSTask *)usergroupsGroupUuidUsersUserIdDelete:( NSString *)userId groupUuid:( NSString *)groupUuid;

/**
 
 
 
 return type: CMAPIUserinfo *
 */
- (AWSTask *)userinfoGet;

/**
 
 
 @param fbAccessToken 
 
 return type: CMAPIOpenIdToken *
 */
- (AWSTask *)usersGetOpenIdTokenGet:(nullable NSString *)fbAccessToken;

@end

NS_ASSUME_NONNULL_END
