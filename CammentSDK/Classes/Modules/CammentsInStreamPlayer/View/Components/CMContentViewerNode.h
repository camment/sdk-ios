//
// Created by Alexander Fedosov on 16.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CMContentType) {
    CMContentTypeVideo = 0,
    CMContentTypeHTML,
};

@protocol CMContentViewerNode <NSObject>

- (void)openContentAtUrl:(NSURL *)url;

@end