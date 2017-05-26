//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMCammentRecorderInteractorOutput <NSObject>

- (void)recorderDidFinishAVAsset:(AVAsset *)asset;

- (void)recorderDidFinishExportingToURL:(NSURL *)url;
@end