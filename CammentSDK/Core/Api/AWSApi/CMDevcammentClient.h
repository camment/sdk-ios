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

#import "CMInvitationInRequest.h"
#import "CMInvitation.h"
#import "CMShowList.h"
#import "CMShow.h"
#import "CMCammentList.h"
#import "CMCammentInRequest.h"
#import "CMCamment.h"
#import "CMUsergroup.h"
#import "CMUserInAddToGroupRequest.h"
#import "CMUserinfoInRequest.h"


NS_ASSUME_NONNULL_BEGIN

/**
 The service client object.
 */
@interface CMDevcammentClient: AWSAPIGatewayClient

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

     let serviceClient = CMDevcammentClient.defaultClient()

 *Objective-C*

     CMDevcammentClient *serviceClient = [CMDevcammentClient defaultClient];

 Alternatively, this configuration could also be set in the `info.plist` file of your app under `AWS` dictionary with a configuration dictionary by name `CMDevcammentClient`.

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
         CMDevcammentClient.registerClientWithConfiguration(configuration, forKey: "USWest2CMDevcammentClient")

         return true
     }

 *Objective-C*

     - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
         AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                         identityPoolId:@"YourIdentityPoolId"];
         AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSWest2
                                                                              credentialsProvider:credentialsProvider];

         [CMDevcammentClient registerClientWithConfiguration:configuration forKey:@"USWest2CMDevcammentClient"];

         return YES;
     }

 Then call the following to get the service client:

 *Swift*

     let serviceClient = CMDevcammentClient(forKey: "USWest2CMDevcammentClient")

 *Objective-C*

     CMDevcammentClient *serviceClient = [CMDevcammentClient clientForKey:@"USWest2CMDevcammentClient"];

 @warning After calling this method, do not modify the configuration object. It may cause unspecified behaviors.

 @param configuration A service configuration object.
 @param key           A string to identify the service client.
 */
+ (void)registerClientWithConfiguration:(AWSServiceConfiguration *)configuration forKey:(NSString *)key;

/**
 Retrieves the service client associated with the key. You need to call `+ registerClientWithConfiguration:forKey:` before invoking this method or alternatively, set the configuration in your application's `info.plist` file. If `+ registerClientWithConfiguration:forKey:` has not been called in advance or if a configuration is not present in the `info.plist` file of the app, this method returns `nil`.

 For example, set the default service configuration in `- application:didFinishLaunchingWithOptions:`

 *Swift*

     func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
         let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "YourIdentityPoolId")
         let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialProvider)
         CMDevcammentClient.registerClientWithConfiguration(configuration, forKey: "USWest2CMDevcammentClient")

         return true
     }

 *Objective-C*

     - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
         AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                         identityPoolId:@"YourIdentityPoolId"];
         AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSWest2
                                                                              credentialsProvider:credentialsProvider];

         [CMDevcammentClient registerClientWithConfiguration:configuration forKey:@"USWest2CMDevcammentClient"];

         return YES;
     }

 Then call the following to get the service client:

 *Swift*

     let serviceClient = CMDevcammentClient(forKey: "USWest2CMDevcammentClient")

 *Objective-C*

     CMDevcammentClient *serviceClient = [CMDevcammentClient clientForKey:@"USWest2CMDevcammentClient"];

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
 
 
 @param body 
 
 return type: CMInvitation *
 */
- (AWSTask *)invitationsPost:( CMInvitationInRequest *)body;

/**
 
 
 
 return type: CMShowList *
 */
- (AWSTask *)showsGet;

/**
 
 
 @param uuid 
 
 return type: CMShow *
 */
- (AWSTask *)showsUuidGet:( NSString *)uuid;

/**
 
 
 @param uuid 
 
 return type: CMCammentList *
 */
- (AWSTask *)showsUuidCammentsGet:( NSString *)uuid;

/**
 
 
 @param uuid 
 @param body 
 
 return type: CMCamment *
 */
- (AWSTask *)showsUuidCammentsPost:( NSString *)uuid body:( CMCammentInRequest *)body;

/**
 
 
 @param cammentUuid 
 @param uuid 
 
 return type: 
 */
- (AWSTask *)showsUuidCammentsCammentUuidDelete:( NSString *)cammentUuid uuid:( NSString *)uuid;

/**
 
 
 
 return type: CMUsergroup *
 */
- (AWSTask *)usergroupsPost;

/**
 
 
 @param groupUuid 
 
 return type: CMCammentList *
 */
- (AWSTask *)usergroupsGroupUuidCammentsGet:( NSString *)groupUuid;

/**
 
 
 @param groupUuid 
 @param body 
 
 return type: CMCamment *
 */
- (AWSTask *)usergroupsGroupUuidCammentsPost:( NSString *)groupUuid body:( CMCammentInRequest *)body;

/**
 
 
 @param groupUuid 
 @param body 
 
 return type: 
 */
- (AWSTask *)usergroupsGroupUuidUsersPost:( NSString *)groupUuid body:( CMUserInAddToGroupRequest *)body;

/**
 
 
 @param body 
 
 return type: 
 */
- (AWSTask *)userinfoPost:( CMUserinfoInRequest *)body;

@end

NS_ASSUME_NONNULL_END
