//
// Created by Alexander Fedosov on 27.10.2017.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CMVideoAd : NSObject

@property(nonatomic, strong) NSURL *videoURL;

@property(nonatomic, strong) NSURL *targetUrl;

@property(nonatomic) dispatch_block_t onClickAction;

- (instancetype)initWithVideoURL:(NSURL *)videoUrl linkUrl:(NSURL *)targetUrl;

@end