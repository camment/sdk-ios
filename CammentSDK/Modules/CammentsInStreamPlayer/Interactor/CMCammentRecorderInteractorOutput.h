//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMCammentRecorderInteractorOutput <NSObject>

- (void)recorderDidFinishAVAsset:(AVAsset *)asset uuid:(NSString *)uuid;

- (void)recorderDidFinishExportingToURL:(NSURL *)url uuid:(NSString *)uuid;
@end