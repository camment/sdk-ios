//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMCammentRecorderInteractorInput.h"

@protocol CMCammentRecorderInteractorOutput;

@interface CMCammentRecorderInteractor: NSObject<CMCammentRecorderInteractorInput>

@property (nonatomic, weak) id<CMCammentRecorderInteractorOutput> output;

@end