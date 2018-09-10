//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMServerListenerCredentials.h"
#import "CMAppConfig.h"

const NSString * kCMServerCredetialsDefaultCertificateId = @"defaultIotCertificate";

@implementation CMServerListenerCredentials

- (instancetype)initWithAppConfig:(CMAppConfig *)appConfig {
    NSString *defaultSertificateId = [NSString stringWithFormat:@"%@-new_%@",
                                          kCMServerCredetialsDefaultCertificateId,
                                          appConfig.sdkEnvironment
                                      ];
    
    return [self initWithClientId:[NSUUID new].UUIDString
                          keyFile:appConfig.iotCertFile
                       passPhrase:appConfig.iotCertPassPhrase
                    certificateId:defaultSertificateId];
}

- (instancetype)initWithClientId:(NSString *)clientId
                         keyFile:(NSString *)p12KeyFile
                      passPhrase:(NSString *)passPhrase
                   certificateId:(NSString *)certificateId
{
    self = [super init];
    if (self) {
        self.clientId = clientId;
        self.p12KeyFile = p12KeyFile;
        self.passPhrase = passPhrase;
        self.certificateId = certificateId;
    }
    return self;
}


@end
