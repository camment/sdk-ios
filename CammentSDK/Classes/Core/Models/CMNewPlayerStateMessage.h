/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMNewPlayerStateMessage.value
 */

#import <Foundation/Foundation.h>

@interface CMNewPlayerStateMessage : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *groupUuid;
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, readonly) double timestamp;

- (instancetype)initWithGroupUuid:(NSString *)groupUuid isPlaying:(BOOL)isPlaying timestamp:(double)timestamp;

@end

