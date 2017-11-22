//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AWSIoTDataManager;
@class CMServerListenerCredentials;
@class RACSubject;
@class CMServerMessage;
@class CMUsersGroup;

@class CMServerMessageController;

@interface CMServerListener : NSObject

@property(nonatomic, strong, readonly) AWSIoTDataManager *dataManager;
@property(nonatomic, readonly) CMServerListenerCredentials *credentials;
@property(nonatomic, readonly) CMServerMessageController *messageController;

@property(nonatomic, copy) NSString *cognitoUuid;

- (instancetype)initWithCredentials:(CMServerListenerCredentials *)credentials
                  messageController:(CMServerMessageController *)messageController
                        dataManager:(AWSIoTDataManager *)dataManager;

- (void)connect;
- (void)resubscribeToNewIdentity:(NSString *)newIdentity;

@end