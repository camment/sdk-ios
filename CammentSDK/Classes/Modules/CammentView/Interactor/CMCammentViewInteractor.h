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

@class CMAPIDevcammentClient;

@interface CMCammentViewInteractor : NSObject<CMCammentViewInteractorInput>

@property (nonatomic, weak) id<CMCammentViewInteractorOutput> output;

@property(nonatomic) int maxUploadRetries;

- (instancetype)initWithAPIClient:(CMAPIDevcammentClient *)APIClient NS_DESIGNATED_INITIALIZER;

@end