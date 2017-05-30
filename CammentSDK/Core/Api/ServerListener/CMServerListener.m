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
#import "CMServerMessage.h"

@implementation CMServerListener

+ (CMServerListener *)instanceWithCredentials:(CMServerListenerCredentials *)credentials {
    static CMServerListener *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] initWithCredentials:credentials];
        }
    }

    return _instance;
}

- (instancetype)initWithCredentials:(CMServerListenerCredentials *)credentials {
    self = [super init];
    if (self) {
        _credentials = credentials;
        _dataManager = [AWSIoTDataManager defaultIoTDataManager];
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

    [self importIdentity];
    BOOL initialized = [_dataManager connectWithClientId:_credentials.clientId
                                            cleanSession:YES
                                           certificateId:_credentials.certificateId
                                          statusCallback:^(AWSIoTMQTTStatus status) {
        
                                              _isConnected = status == AWSIoTMQTTStatusConnected;
                                              if (_isConnected) {
                                                  [self subscribe];
                                              }
                                          }];

}

- (void)subscribe {
    [_dataManager subscribeToTopic:@"camment/app"
                               QoS:AWSIoTMQTTQoSMessageDeliveryAttemptedAtMostOnce
                   messageCallback:^(NSData *data) {
                       [self processMessage:data];
                   }];
}

- (void)processMessage:(NSData *)messageData {
    CMServerMessage *message = [CMServerMessage new];
    message.rawMessage = messageData;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:messageData
                                                               options:NSJSONReadingAllowFragments
                                                                 error:nil];
    if (jsonObject) {
        message.json = jsonObject;
        NSLog(@"%@", jsonObject);
    }

    [_messageSubject sendNext:message];
}

@end
