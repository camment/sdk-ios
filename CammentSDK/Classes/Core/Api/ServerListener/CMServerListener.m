//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AWSIoT/AWSIoT.h>
#import <AWSIoT/AWSIoTManager.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <AVFoundation/AVFoundation.h>
#import "CMServerListener.h"
#import "CMServerListenerCredentials.h"
#import "CMAppConfig.h"
#import "CMStore.h"
#import "CMServerMessage.h"
#import "CMCammentBuilder.h"
#import "CMUser.h"
#import "CMUserBuilder.h"
#import "AWSMobileAnalyticsMonetizationEventBuilder.h"
#import "CMUserJoinedMessage.h"
#import "CMUserJoinedMessageBuilder.h"
#import "CMServerMessageParser.h"
#import "CMUsersGroup.h"

static CMServerListener *_instance = nil;

@implementation CMServerListener

+ (CMServerListener *)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithCredentials:[CMServerListenerCredentials defaultCredentials]];
    });

    return _instance;
}

- (instancetype)initWithCredentials:(CMServerListenerCredentials *)credentials {
    self = [super init];
    if (self) {
        _credentials = credentials;
        _messageSubject = [RACSubject new];
        _isConnected = NO;
    }
    return self;
}

- (BOOL)importIdentity {
    NSString *identityPath = nil;

    NSBundle *bundle = [NSBundle cammentSDKBundle];
    identityPath = [bundle pathForResource:_credentials.p12KeyFile ofType:@"p12"];

    if (!identityPath) {return NO;}

    NSData *certData = [NSData dataWithContentsOfFile:identityPath];
    if (!certData) {return NO;}

    [AWSIoTManager deleteCertificate];
    return [AWSIoTManager importIdentityFromPKCS12Data:certData
                                            passPhrase:_credentials.passPhrase
                                         certificateId:_credentials.certificateId];
}

- (void)connect {
    if (_isConnected) { return; }
    [CMStore instance].isConnected = NO;

    if (![self importIdentity]) {
        DDLogError(@"Couldn't import iot certificate");
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL initialized = [_dataManager connectWithClientId:_credentials.clientId
                                                cleanSession:YES
                                               certificateId:_credentials.certificateId
                                              statusCallback:^(AWSIoTMQTTStatus status) {
                                                  
                                                  switch (status) {
                                                          
                                                      case AWSIoTMQTTStatusUnknown:
                                                          break;
                                                      case AWSIoTMQTTStatusConnecting:
                                                          break;
                                                      case AWSIoTMQTTStatusConnected:
                                                          DDLogInfo(@"Iot connected");
                                                          break;
                                                      case AWSIoTMQTTStatusDisconnected:
                                                          break;
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
    });
}

- (void)subscribe {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_dataManager subscribeToTopic:@"camment/app"
                                   QoS:AWSIoTMQTTQoSMessageDeliveryAttemptedAtMostOnce
                       messageCallback:^(NSData *data) {
                           [self processMessage:data];
                       }];
        [self subscribeToNewIdentity:self.cognitoUuid];
    });
}

- (void)subscribeToNewIdentity:(NSString *)newIdentity {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.cognitoUuid) {
            NSString *oldChannel = [NSString stringWithFormat:@"camment/user/%@", self.cognitoUuid];
            [_dataManager unsubscribeTopic:oldChannel];
            DDLogInfo(@"Unsubscribed from %@", oldChannel);
        }
        
        if (newIdentity) {
            NSString *newChannel = [NSString stringWithFormat:@"camment/user/%@", newIdentity];
            [_dataManager subscribeToTopic:newChannel
                                       QoS:AWSIoTMQTTQoSMessageDeliveryAttemptedAtMostOnce
                           messageCallback:^(NSData *data) {
                               [self processMessage:data];
                           }];
            self.cognitoUuid = newIdentity;
            DDLogInfo(@"Subscribed to %@", newChannel);
        }
    });
}

- (void)processMessage:(NSData *)messageData {

    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:messageData
                                                               options:NSJSONReadingAllowFragments
                                                                 error:nil];
    if (!jsonObject) {
        return;
    }

    DDLogVerbose(@"server message %@", jsonObject);

    CMServerMessage *serverMessage = [[[CMServerMessageParser alloc] initWithMessageDictionary:jsonObject] parseMessage];
    if (!serverMessage) {return;}

    DDLogVerbose(@"Got message %@", serverMessage);
    [_messageSubject sendNext:serverMessage];
}

- (void)redubscribeToNewIdentity:(NSString *)newIdentity {
    _dataManager = [AWSIoTDataManager IoTDataManagerForKey:CMIotManagerName];
    if (self.isConnected) {
        [self subscribeToNewIdentity:newIdentity];
        return;
    }

    self.cognitoUuid = newIdentity;
    [self connect];
}
@end
