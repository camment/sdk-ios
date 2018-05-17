#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMNewPlayerStateMessage.h"
#import "CMNewPlayerStateMessageBuilder.h"

@implementation CMNewPlayerStateMessageBuilder
{
  NSString *_groupUuid;
  BOOL _isPlaying;
  double _timestamp;
}

+ (instancetype)newPlayerStateMessage
{
  return [[CMNewPlayerStateMessageBuilder alloc] init];
}

+ (instancetype)newPlayerStateMessageFromExistingNewPlayerStateMessage:(CMNewPlayerStateMessage *)existingNewPlayerStateMessage
{
  return [[[[CMNewPlayerStateMessageBuilder newPlayerStateMessage]
            withGroupUuid:existingNewPlayerStateMessage.groupUuid]
           withIsPlaying:existingNewPlayerStateMessage.isPlaying]
          withTimestamp:existingNewPlayerStateMessage.timestamp];
}

- (CMNewPlayerStateMessage *)build
{
  return [[CMNewPlayerStateMessage alloc] initWithGroupUuid:_groupUuid isPlaying:_isPlaying timestamp:_timestamp];
}

- (instancetype)withGroupUuid:(NSString *)groupUuid
{
  _groupUuid = [groupUuid copy];
  return self;
}

- (instancetype)withIsPlaying:(BOOL)isPlaying
{
  _isPlaying = isPlaying;
  return self;
}

- (instancetype)withTimestamp:(double)timestamp
{
  _timestamp = timestamp;
  return self;
}

@end

