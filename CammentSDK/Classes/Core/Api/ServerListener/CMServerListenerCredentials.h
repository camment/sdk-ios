//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString * kCMServerCredetialsDefaultCertificateId;

@class CMAppConfig;

@interface CMServerListenerCredentials : NSObject

@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *p12KeyFile;
@property (nonatomic, copy) NSString *passPhrase;
@property (nonatomic, copy) NSString *certificateId;

- (instancetype)initWithAppConfig:(CMAppConfig *)appConfig;

- (instancetype)initWithClientId:(NSString *)clientId
                         keyFile:(NSString *)p12KeyFile
                      passPhrase:(NSString *)passPhrase
                   certificateId:(NSString *)certificateId NS_DESIGNATED_INITIALIZER;

@end
