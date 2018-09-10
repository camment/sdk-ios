#import <Foundation/Foundation.h>

@class CMNewPlayerStateMessage;

@interface CMNewPlayerStateMessageBuilder : NSObject

+ (instancetype)newPlayerStateMessage;

+ (instancetype)newPlayerStateMessageFromExistingNewPlayerStateMessage:(CMNewPlayerStateMessage *)existingNewPlayerStateMessage;

- (CMNewPlayerStateMessage *)build;

- (instancetype)withGroupUuid:(NSString *)groupUuid;

- (instancetype)withIsPlaying:(BOOL)isPlaying;

- (instancetype)withTimestamp:(double)timestamp;

@end

