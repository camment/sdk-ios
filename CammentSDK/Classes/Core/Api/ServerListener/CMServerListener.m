//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AWSIoT/AWSIoT.h>
#import "CMServerListener.h"
#import "CMServerListenerCredentials.h"
#import "CMServerMessage.h"
#import "CMServerMessageParser.h"
#import "CMServerMessageController.h"

@implementation CMServerListener

- (instancetype)initWithCredentials:(CMServerListenerCredentials *)credentials
                  messageController:(CMServerMessageController *)messageController
                        dataManager:(AWSIoTDataManager *)dataManager
{
    self = [super init];

    if (self) {
        _credentials = credentials;
        _messageController = messageController;
        _dataManager = dataManager;
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

- (BOOL)isConnected {
    return self.dataManager.getConnectionStatus == AWSIoTMQTTStatusConnected;
}

- (void)connect {
    if (self.isConnected) { return; }

    if (![self importIdentity]) {
        DDLogError(@"Couldn't import iot certificate");
    }

    __weak typeof(self) __wealSelf = self;
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
                                                          [__wealSelf subscribe];
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
                                              }];
        if (!initialized) {
            DDLogError(@"Iot client wasn't initialized");
        }
    });
}

- (void)subscribe {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_dataManager subscribeToTopic:@"camment/app"
                                   QoS:AWSIoTMQTTQoSMessageDeliveryAttemptedAtLeastOnce
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

    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:messageData
                                                               options:NSJSONReadingAllowFragments
                                                                 error:&error];
    if (!jsonObject || error) {
        DDLogError(@"Could not create json object from message %@", error);
        return;
    }

    CMServerMessage *serverMessage = [[[CMServerMessageParser alloc] initWithMessageDictionary:jsonObject] parseMessage];
    if (!serverMessage) {
        DDLogError(@"Could not parse server message %@", jsonObject);
        return;
    }

    DDLogVerbose(@"Got message %@", serverMessage);
    [self.messageController handleServerMessage:serverMessage];
}

- (void)resubscribeToNewIdentity:(NSString *)newIdentity {
    if ([self isConnected]) {
        [self subscribeToNewIdentity:newIdentity];
    } else {
        self.cognitoUuid = newIdentity;
        [self connect];
    }
}
@end
