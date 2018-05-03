#import <Foundation/Foundation.h>

@class CMVideoSyncEventMessage;

@interface CMVideoSyncEventMessageBuilder : NSObject

+ (instancetype)videoSyncEventMessage;

+ (instancetype)videoSyncEventMessageFromExistingVideoSyncEventMessage:(CMVideoSyncEventMessage *)existingVideoSyncEventMessage;

- (CMVideoSyncEventMessage *)build;

- (instancetype)withEvent:(NSString *)event;

- (instancetype)withGroupUUID:(NSString *)groupUUID;

- (instancetype)withShowUUID:(NSString *)showUUID;

- (instancetype)withIsPlaying:(BOOL)isPlaying;

- (instancetype)withTimestamp:(double)timestamp;

@end

