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
 


#import "CMAPIDevcammentClient.h"
#import <AWSCore/AWSCore.h>
#import <AWSCore/AWSSignature.h>
#import <AWSCore/AWSSynchronizedMutableDictionary.h>

#import "CMAPIError.h"
#import "CMAPIDeeplink.h"
#import "CMAPIPasscodeInRequest.h"
#import "CMAPIFacebookFriendList.h"
#import "CMAPIShowList.h"
#import "CMAPIShow.h"
#import "CMAPICammentList.h"
#import "CMAPICammentInRequest.h"
#import "CMAPICamment.h"
#import "CMAPIUsergroup.h"
#import "CMAPIShowUuid.h"
#import "CMAPIAcceptInvitationRequest.h"
#import "CMAPIUserinfoList.h"
#import "CMAPIUserinfo.h"
#import "CMAPIUserinfoInRequest.h"

@interface AWSAPIGatewayClient()

// Networking
@property (nonatomic, strong) NSURLSession *session;

// For requests
@property (nonatomic, strong) NSURL *baseURL;

// For responses
@property (nonatomic, strong) NSDictionary *HTTPHeaderFields;
@property (nonatomic, assign) NSInteger HTTPStatusCode;

- (AWSTask *)invokeHTTPRequest:(NSString *)HTTPMethod
                     URLString:(NSString *)URLString
                pathParameters:(NSDictionary *)pathParameters
               queryParameters:(NSDictionary *)queryParameters
              headerParameters:(NSDictionary *)headerParameters
                          body:(id)body
                 responseClass:(Class)responseClass;

@end

@interface CMAPIDevcammentClient()

@property (nonatomic, strong) AWSServiceConfiguration *configuration;

@end

@interface AWSServiceConfiguration()

@property (nonatomic, strong) AWSEndpoint *endpoint;

@end

@implementation CMAPIDevcammentClient

static NSString *const AWSInfoClientKey = @"CMAPIDevcammentClient";

@synthesize configuration = _configuration;

static AWSSynchronizedMutableDictionary *_serviceClients = nil;

+ (instancetype)defaultClient {
    AWSServiceConfiguration *serviceConfiguration = nil;
    AWSServiceInfo *serviceInfo = [[AWSInfo defaultAWSInfo] defaultServiceInfo:AWSInfoClientKey];
    if (serviceInfo) {
        serviceConfiguration = [[AWSServiceConfiguration alloc] initWithRegion:serviceInfo.region
                                                           credentialsProvider:serviceInfo.cognitoCredentialsProvider];
    } else if ([AWSServiceManager defaultServiceManager].defaultServiceConfiguration) {
        serviceConfiguration = AWSServiceManager.defaultServiceManager.defaultServiceConfiguration;
    } else {
        serviceConfiguration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUnknown
                                                           credentialsProvider:nil];
    }

    static CMAPIDevcammentClient *_defaultClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultClient = [[CMAPIDevcammentClient alloc] initWithConfiguration:serviceConfiguration];
    });

    return _defaultClient;
}

+ (void)registerClientWithConfiguration:(AWSServiceConfiguration *)configuration forKey:(NSString *)key {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _serviceClients = [AWSSynchronizedMutableDictionary new];
    });
    [_serviceClients setObject:[[CMAPIDevcammentClient alloc] initWithConfiguration:configuration]
                        forKey:key];
}

+ (instancetype)clientForKey:(NSString *)key {
    @synchronized(self) {
        CMAPIDevcammentClient *serviceClient = [_serviceClients objectForKey:key];
        if (serviceClient) {
            return serviceClient;
        }

        AWSServiceInfo *serviceInfo = [[AWSInfo defaultAWSInfo] serviceInfo:AWSInfoClientKey
                                                                     forKey:key];
        if (serviceInfo) {
            AWSServiceConfiguration *serviceConfiguration = [[AWSServiceConfiguration alloc] initWithRegion:serviceInfo.region
                                                                                        credentialsProvider:serviceInfo.cognitoCredentialsProvider];
            [CMAPIDevcammentClient registerClientWithConfiguration:serviceConfiguration
                                                    forKey:key];
        }

        return [_serviceClients objectForKey:key];
    }
}

+ (void)removeClientForKey:(NSString *)key {
    [_serviceClients removeObjectForKey:key];
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"`- init` is not a valid initializer. Use `+ defaultClient` or `+ clientForKey:` instead."
                                 userInfo:nil];
    return nil;
}

- (instancetype)initWithConfiguration:(AWSServiceConfiguration *)configuration {
    if (self = [super init]) {
        _configuration = [configuration copy];

        NSString *URLString = @"https://76unbx2jub.execute-api.eu-central-1.amazonaws.com/dev";
        if ([URLString hasSuffix:@"/"]) {
            URLString = [URLString substringToIndex:[URLString length] - 1];
        }
        _configuration.endpoint = [[AWSEndpoint alloc] initWithRegion:_configuration.regionType
                                                              service:AWSServiceAPIGateway
                                                                  URL:[NSURL URLWithString:URLString]];

        AWSSignatureV4Signer *signer =  [[AWSSignatureV4Signer alloc] initWithCredentialsProvider:_configuration.credentialsProvider
                                                                                         endpoint:_configuration.endpoint];

        _configuration.baseURL = _configuration.endpoint.URL;
        _configuration.requestInterceptors = @[[AWSNetworkingRequestInterceptor new], signer];
    }
    
    return self;
}

- (AWSTask *)deferredDeeplinkDeeplinkHashGet:(NSString *)deeplinkHash {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     @"deeplinkHash": deeplinkHash
                                     };
    
    return [self invokeHTTPRequest:@"GET"
                         URLString:@"/deferred-deeplink/{deeplinkHash}"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:nil
                     responseClass:[CMAPIDeeplink class]];
}

- (AWSTask *)demoValidatePasscodePost:(CMAPIPasscodeInRequest *)body {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     
                                     };
    
    return [self invokeHTTPRequest:@"POST"
                         URLString:@"/demo/validate-passcode"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:body
                     responseClass:nil];
}

- (AWSTask *)meFbFriendsGet:(NSString *)fbAccessToken {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      @"fbAccessToken": fbAccessToken
                                      };
    NSDictionary *pathParameters = @{
                                     
                                     };
    
    return [self invokeHTTPRequest:@"GET"
                         URLString:@"/me/fb-friends"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:nil
                     responseClass:[CMAPIFacebookFriendList class]];
}

- (AWSTask *)showsGet:(NSString *)passcode {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      @"passcode": passcode
                                      };
    NSDictionary *pathParameters = @{
                                     
                                     };
    
    return [self invokeHTTPRequest:@"GET"
                         URLString:@"/shows"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:nil
                     responseClass:[CMAPIShowList class]];
}

- (AWSTask *)showsUuidGet:(NSString *)uuid {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     @"uuid": uuid
                                     };
    
    return [self invokeHTTPRequest:@"GET"
                         URLString:@"/shows/{uuid}"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:nil
                     responseClass:[CMAPIShow class]];
}

- (AWSTask *)showsUuidCammentsGet:(NSString *)uuid {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     @"uuid": uuid
                                     };
    
    return [self invokeHTTPRequest:@"GET"
                         URLString:@"/shows/{uuid}/camments"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:nil
                     responseClass:[CMAPICammentList class]];
}

- (AWSTask *)showsUuidCammentsPost:(NSString *)uuid body:(CMAPICammentInRequest *)body {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     @"uuid": uuid,
                                     
                                     };
    
    return [self invokeHTTPRequest:@"POST"
                         URLString:@"/shows/{uuid}/camments"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:body
                     responseClass:[CMAPICamment class]];
}

- (AWSTask *)usergroupsPost {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     
                                     };
    
    return [self invokeHTTPRequest:@"POST"
                         URLString:@"/usergroups"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:nil
                     responseClass:[CMAPIUsergroup class]];
}

- (AWSTask *)usergroupsTestPost {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     
                                     };
    
    return [self invokeHTTPRequest:@"POST"
                         URLString:@"/usergroups/test"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:nil
                     responseClass:nil];
}

- (AWSTask *)usergroupsGroupUuidCammentsGet:(NSString *)groupUuid {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     @"groupUuid": groupUuid
                                     };
    
    return [self invokeHTTPRequest:@"GET"
                         URLString:@"/usergroups/{groupUuid}/camments"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:nil
                     responseClass:[CMAPICammentList class]];
}

- (AWSTask *)usergroupsGroupUuidCammentsPost:(NSString *)groupUuid body:(CMAPICammentInRequest *)body {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     @"groupUuid": groupUuid,
                                     
                                     };
    
    return [self invokeHTTPRequest:@"POST"
                         URLString:@"/usergroups/{groupUuid}/camments"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:body
                     responseClass:[CMAPICamment class]];
}

- (AWSTask *)usergroupsGroupUuidCammentsCammentUuidDelete:(NSString *)cammentUuid groupUuid:(NSString *)groupUuid {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     @"cammentUuid": cammentUuid,
                                     @"groupUuid": groupUuid
                                     };
    
    return [self invokeHTTPRequest:@"DELETE"
                         URLString:@"/usergroups/{groupUuid}/camments/{cammentUuid}"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:nil
                     responseClass:nil];
}

- (AWSTask *)usergroupsGroupUuidDeeplinkPost:(NSString *)groupUuid body:(CMAPIShowUuid *)body {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     @"groupUuid": groupUuid,
                                     
                                     };
    
    return [self invokeHTTPRequest:@"POST"
                         URLString:@"/usergroups/{groupUuid}/deeplink"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:body
                     responseClass:[CMAPIDeeplink class]];
}

- (AWSTask *)usergroupsGroupUuidInvitationsPut:(NSString *)groupUuid body:(CMAPIAcceptInvitationRequest *)body {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     @"groupUuid": groupUuid,
                                     
                                     };
    
    return [self invokeHTTPRequest:@"PUT"
                         URLString:@"/usergroups/{groupUuid}/invitations"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:body
                     responseClass:nil];
}

- (AWSTask *)usergroupsGroupUuidUsersGet:(NSString *)groupUuid {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     @"groupUuid": groupUuid
                                     };
    
    return [self invokeHTTPRequest:@"GET"
                         URLString:@"/usergroups/{groupUuid}/users"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:nil
                     responseClass:[CMAPIUserinfoList class]];
}

- (AWSTask *)usergroupsGroupUuidUsersPost:(NSString *)groupUuid {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     @"groupUuid": groupUuid
                                     };
    
    return [self invokeHTTPRequest:@"POST"
                         URLString:@"/usergroups/{groupUuid}/users"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:nil
                     responseClass:nil];
}

- (AWSTask *)usergroupsGroupUuidUsersUserIdPut:(NSString *)userId groupUuid:(NSString *)groupUuid {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     @"userId": userId,
                                     @"groupUuid": groupUuid
                                     };
    
    return [self invokeHTTPRequest:@"PUT"
                         URLString:@"/usergroups/{groupUuid}/users/{userId}"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:nil
                     responseClass:nil];
}

- (AWSTask *)usergroupsGroupUuidUsersUserIdDelete:(NSString *)userId groupUuid:(NSString *)groupUuid {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     @"userId": userId,
                                     @"groupUuid": groupUuid
                                     };
    
    return [self invokeHTTPRequest:@"DELETE"
                         URLString:@"/usergroups/{groupUuid}/users/{userId}"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:nil
                     responseClass:nil];
}

- (AWSTask *)userinfoGet {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     
                                     };
    
    return [self invokeHTTPRequest:@"GET"
                         URLString:@"/userinfo"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:nil
                     responseClass:[CMAPIUserinfo class]];
}

- (AWSTask *)userinfoPost:(CMAPIUserinfoInRequest *)body {
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       
                                       };
    NSDictionary *queryParameters = @{
                                      
                                      };
    NSDictionary *pathParameters = @{
                                     
                                     };
    
    return [self invokeHTTPRequest:@"POST"
                         URLString:@"/userinfo"
                    pathParameters:pathParameters
                   queryParameters:queryParameters
                  headerParameters:headerParameters
                              body:body
                     responseClass:nil];
}



@end
