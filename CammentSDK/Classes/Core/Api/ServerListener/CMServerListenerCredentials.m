//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMServerListenerCredentials.h"

const NSString * kCMServerCredetialsDefaultCertificateId = @"defaultIotCertificate";

@implementation CMServerListenerCredentials

+ (CMServerListenerCredentials *)defaultCredentials {
    return [CMServerListenerCredentials new];
}

- (instancetype)init {
    return [self initWithClientId:[NSUUID new].UUIDString
                          keyFile:@"awsiot-identity"
                       passPhrase:@"8uT$BwY+x=DF,M"
                    certificateId:nil];
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
        self.certificateId = (NSString *) (certificateId ?: kCMServerCredetialsDefaultCertificateId);
    }
    return self;
}


@end
