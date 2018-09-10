//
// Created by Alexander Fedosov on 16.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CMContentType) {
    CMContentTypeVideo = 0,
    CMContentTypeHTML,
};

@protocol CMVideoContentNodeDelegate <NSObject>

@optional
- (void)playerDidUpdateCurrentTimeInterval:(NSTimeInterval)timeInterval;
- (void)playerDidPlay:(NSTimeInterval)timeInterval;
- (void)playerDidPause:(NSTimeInterval)timeInterval;

@end

@protocol CMContentViewerNode <NSObject>

@property (nonatomic, weak) id<CMVideoContentNodeDelegate> videoNodeDelegate;

- (void)openContentAtUrl:(NSURL *)url;
- (void)setCurrentTimeInterval:(NSTimeInterval)timeInterval;

- (void)setIsPlaying:(BOOL)playing;
@end