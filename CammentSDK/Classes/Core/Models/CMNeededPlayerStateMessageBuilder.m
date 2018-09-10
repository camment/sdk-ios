#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMNeededPlayerStateMessage.h"
#import "CMNeededPlayerStateMessageBuilder.h"

@implementation CMNeededPlayerStateMessageBuilder
{
  NSString *_groupUUID;
}

+ (instancetype)neededPlayerStateMessage
{
  return [[CMNeededPlayerStateMessageBuilder alloc] init];
}

+ (instancetype)neededPlayerStateMessageFromExistingNeededPlayerStateMessage:(CMNeededPlayerStateMessage *)existingNeededPlayerStateMessage
{
  return [[CMNeededPlayerStateMessageBuilder neededPlayerStateMessage]
          withGroupUUID:existingNeededPlayerStateMessage.groupUUID];
}

- (CMNeededPlayerStateMessage *)build
{
  return [[CMNeededPlayerStateMessage alloc] initWithGroupUUID:_groupUUID];
}

- (instancetype)withGroupUUID:(NSString *)groupUUID
{
  _groupUUID = [groupUUID copy];
  return self;
}

@end

