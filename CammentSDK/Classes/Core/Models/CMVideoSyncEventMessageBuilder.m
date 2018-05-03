#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMVideoSyncEventMessage.h"
#import "CMVideoSyncEventMessageBuilder.h"

@implementation CMVideoSyncEventMessageBuilder
{
  NSString *_event;
  NSString *_groupUUID;
  NSString *_showUUID;
  BOOL _isPlaying;
  double _timestamp;
}

+ (instancetype)videoSyncEventMessage
{
  return [[CMVideoSyncEventMessageBuilder alloc] init];
}

+ (instancetype)videoSyncEventMessageFromExistingVideoSyncEventMessage:(CMVideoSyncEventMessage *)existingVideoSyncEventMessage
{
  return [[[[[[CMVideoSyncEventMessageBuilder videoSyncEventMessage]
              withEvent:existingVideoSyncEventMessage.event]
             withGroupUUID:existingVideoSyncEventMessage.groupUUID]
            withShowUUID:existingVideoSyncEventMessage.showUUID]
           withIsPlaying:existingVideoSyncEventMessage.isPlaying]
          withTimestamp:existingVideoSyncEventMessage.timestamp];
}

- (CMVideoSyncEventMessage *)build
{
  return [[CMVideoSyncEventMessage alloc] initWithEvent:_event groupUUID:_groupUUID showUUID:_showUUID isPlaying:_isPlaying timestamp:_timestamp];
}

- (instancetype)withEvent:(NSString *)event
{
  _event = [event copy];
  return self;
}

- (instancetype)withGroupUUID:(NSString *)groupUUID
{
  _groupUUID = [groupUUID copy];
  return self;
}

- (instancetype)withShowUUID:(NSString *)showUUID
{
  _showUUID = [showUUID copy];
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

