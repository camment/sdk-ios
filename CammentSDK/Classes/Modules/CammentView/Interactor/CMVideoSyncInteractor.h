//
// Created by Alexander Fedosov on 14.05.2018.
//

#import <Foundation/Foundation.h>

@class CMShowMetadata;


@interface CMVideoSyncInteractor : NSObject


- (void)requestNewShowTimestampIfNeeded;

- (void)updateVideoStreamStateIsPlaying:(BOOL)isPlaying show:(CMShowMetadata *)show timestamp:(NSTimeInterval)timestamp;
@end