//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AWSIoT/AWSIoT.h>
#import <AWSIoT/AWSIoTManager.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "CMServerListener.h"
#import "CMServerListenerCredentials.h"
#import "CMAppConfig.h"
#import "CMStore.h"
#import "ServerMessage.h"
#import "CammentBuilder.h"
#import "Camment.h"

static CMServerListener *_instance = nil;

@implementation CMServerListener

+ (CMServerListener *)instance {
    return _instance;
}

+ (CMServerListener *)instanceWithCredentials:(CMServerListenerCredentials *)credentials {

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] initWithCredentials:credentials];
        } else {
            [_instance refreshCredentials:credentials];
        }
    }

    return _instance;
}

- (void)refreshCredentials:(CMServerListenerCredentials *)credentials {
    DDLogVerbose(@"Refreshing iot credentials with id %@", credentials.clientId);
    _credentials = credentials;
    [_dataManager disconnect];
    _isConnected = NO;
}

- (instancetype)initWithCredentials:(CMServerListenerCredentials *)credentials {
    self = [super init];
    if (self) {
        _credentials = credentials;
        _dataManager = [AWSIoTDataManager IoTDataManagerForKey:CMIotManagerName];
        _messageSubject = [RACSubject new];
        _isConnected = NO;
    }
    return self;
}

- (BOOL)importIdentity {
    NSString *identityPath = nil;

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    identityPath = [bundle pathForResource:_credentials.p12KeyFile ofType:@"p12"];

    if (!identityPath) { return NO; }

    NSData *certData = [NSData dataWithContentsOfFile:identityPath];
    if (!certData) { return NO; }

    return [AWSIoTManager importIdentityFromPKCS12Data:certData
                                            passPhrase:_credentials.passPhrase
                                         certificateId:_credentials.certificateId];
}

- (void)connect {
    if (_isConnected) { return; }
    [CMStore instance].isConnected = NO;

    [self importIdentity];
    BOOL initialized = [_dataManager connectWithClientId:_credentials.clientId
                                            cleanSession:YES
                                           certificateId:_credentials.certificateId
                                          statusCallback:^(AWSIoTMQTTStatus status) {

                                              switch (status) {

                                                  case AWSIoTMQTTStatusUnknown:break;
                                                  case AWSIoTMQTTStatusConnecting:break;
                                                  case AWSIoTMQTTStatusConnected:break;
                                                  case AWSIoTMQTTStatusDisconnected:break;
                                                  case AWSIoTMQTTStatusConnectionRefused:
                                                      DDLogError(@"Iot connection refused");
                                                      break;
                                                  case AWSIoTMQTTStatusConnectionError:
                                                      DDLogError(@"Iot connection error");
                                                      break;
                                                  case AWSIoTMQTTStatusProtocolError:
                                                      DDLogError(@"Iot protocol error");
                                                      break;
                                              }
                                              _isConnected = status == AWSIoTMQTTStatusConnected;
                                              [CMStore instance].isConnected = _isConnected;
                                              if (_isConnected) {
                                                  [self subscribe];
                                              }
                                          }];
    if (!initialized) {
        DDLogError(@"Iot client wasn't initialized");
    }

}

- (void)subscribe {
    [_dataManager subscribeToTopic:@"camment/app"
                               QoS:AWSIoTMQTTQoSMessageDeliveryAttemptedAtMostOnce
                   messageCallback:^(NSData *data) {
                       [self processMessage:data];
                   }];
}

- (void)processMessage:(NSData *)messageData {

    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:messageData
                                                               options:NSJSONReadingAllowFragments
                                                                 error:nil];
    if (!jsonObject) {
        return;
    }

    NSString *type = jsonObject[@"type"];
    NSDictionary *body = jsonObject[@"body"];

    ServerMessage *serverMessage = nil;

    if ([type isEqualToString:@"camment"]) {
        Camment *camment = [[Camment alloc] initWithShowUuid:body[@"showUuid"]
                                               userGroupUuid:body[@"userGroupUuid"]
                                                        uuid:body[@"uuid"]
                                                   remoteURL:body[@"url"]
                                                    localURL:nil
                                                thumbnailURL:body[@"thumbnail"]
                                                  localAsset:nil];
        serverMessage = [ServerMessage cammentWithCamment:camment];

    } else if ([type isEqualToString:@"invitation"]) {
        Invitation *invitation = [[Invitation alloc] initWithUserGroupUuid:body[@"groupUuid"]
                                                           userCognitoUuid:body[@"userCognitoIdentityId"]];
        serverMessage = [ServerMessage invitationWithInvitation:invitation];
    }

    if (!serverMessage) { return; }

    NSLog(@"Got message %@", serverMessage);
    [_messageSubject sendNext:serverMessage];
}

@end
