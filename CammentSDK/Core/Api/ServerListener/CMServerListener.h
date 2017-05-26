//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AWSIoTDataManager;
@class CMServerListenerCredentials;
@class RACSubject;
@class CMServerMessage;


@interface CMServerListener : NSObject

@property (nonatomic, strong, readonly) AWSIoTDataManager *dataManager;
@property (nonatomic, assign, readonly) BOOL isConnected;
@property (nonatomic, readonly) CMServerListenerCredentials *credentials;
@property (nonatomic, readonly) RACSubject<CMServerMessage *> *messageSubject;

- (instancetype)initWithCredentials:(CMServerListenerCredentials *)credentials;

- (void)connect;

+ (CMServerListener *)instanceWithCredentials:(CMServerListenerCredentials *)credentials;


@end