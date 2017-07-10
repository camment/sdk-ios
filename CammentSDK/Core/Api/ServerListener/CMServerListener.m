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
#import "ServerMessage.h"
#import "CammentBuilder.h"
#import "User.h"
#import "UserBuilder.h"
#import "AWSMobileAnalyticsMonetizationEventBuilder.h"
#import "UserJoinedMessage.h"
#import "UserJoinedMessageBuilder.h"
#import "CMServerMessageParser.h"

static CMServerListener *_instance = nil;

@implementation CMServerListener

+ (CMServerListener *)instance {
    if (_instance) {
        return _instance;
    }
    
    return [self instanceWithCredentials:[CMServerListenerCredentials defaultCredentials]];
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

    if (!identityPath) {return NO;}

    NSData *certData = [NSData dataWithContentsOfFile:identityPath];
    if (!certData) {return NO;}

    return [AWSIoTManager importIdentityFromPKCS12Data:certData
                                            passPhrase:_credentials.passPhrase
                                         certificateId:_credentials.certificateId];
}

- (void)connect {
    if (_isConnected) {return;}
    [CMStore instance].isConnected = NO;

    [self importIdentity];
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

    DDLogVerbose(@"server message %@", jsonObject);

    ServerMessage *serverMessage = [[[CMServerMessageParser alloc] initWithMessageDictionary:jsonObject] parseMessage];
    if (!serverMessage) {return;}

    DDLogVerbose(@"Got message %@", serverMessage);
    [_messageSubject sendNext:serverMessage];
}

@end
