//
//  CMCammentViewCMCammentViewInteractor.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMCammentViewInteractorInput.h"
#import "CMCammentViewInteractorOutput.h"

FOUNDATION_EXPORT NSString *const CMCammentViewInteractorErrorDomain;
typedef NS_ENUM(NSInteger, CMCammentViewInteractorErrorType) {
    CMCammentViewInteractorErrorUnknown,
    CMCammentViewInteractorErrorMissingRequiredParameters,
    CMCammentViewInteractorErrorProvidedParametersAreIncorrect
};

@class CMAPIDevcammentClient;
@class CMCammentUploader;

@interface CMCammentViewInteractor : NSObject<CMCammentViewInteractorInput>

@property (nonatomic, weak) id<CMCammentViewInteractorOutput> output;

@property(nonatomic) int maxUploadRetries;

- (instancetype)initWithCammentUploader:(CMCammentUploader *)cammentUploader;
@end
