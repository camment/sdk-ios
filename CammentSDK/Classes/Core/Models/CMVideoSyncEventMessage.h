/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMVideoSyncEventMessage.value
 */

#import <Foundation/Foundation.h>

@interface CMVideoSyncEventMessage : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *event;
@property (nonatomic, readonly, copy) NSString *groupUUID;
@property (nonatomic, readonly, copy) NSString *showUUID;
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, readonly) double timestamp;

- (instancetype)initWithEvent:(NSString *)event groupUUID:(NSString *)groupUUID showUUID:(NSString *)showUUID isPlaying:(BOOL)isPlaying timestamp:(double)timestamp;

@end

