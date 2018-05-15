//
// Created by Alexander Fedosov on 14.05.2018.
//

#import <Foundation/Foundation.h>

@class CMShowMetadata;
@class CMNeededPlayerStateMessage;

@interface CMVideoSyncInteractor : NSObject


- (void)requestNewShowTimestampIfNeeded:(NSString *)groupUuid;

- (void)updateVideoStreamStateIsPlaying:(BOOL)isPlaying show:(CMShowMetadata *)show timestamp:(NSTimeInterval)timestamp;

- (void)requestNewTimestampsFromHostAppIfNeeded:(NSString *)groupUuid;

@end
