//
// Created by Alexander Fedosov on 27.10.2017.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMVideoAd.h"


@implementation CMVideoAd {

}

- (instancetype)initWithVideoURL:(NSURL *)videoUrl linkUrl:(NSURL *)targetUrl {
    self = [super init];
    if (self) {
        self.videoURL = videoUrl;
        self.targetUrl = targetUrl;
    }
    
    return self;
}

@end