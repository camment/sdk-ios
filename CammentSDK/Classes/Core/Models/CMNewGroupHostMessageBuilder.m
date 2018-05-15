#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMNewGroupHostMessage.h"
#import "CMNewGroupHostMessageBuilder.h"

@implementation CMNewGroupHostMessageBuilder
{
  NSString *_groupUuid;
  NSString *_hostId;
}

+ (instancetype)newGroupHostMessage
{
  return [[CMNewGroupHostMessageBuilder alloc] init];
}

+ (instancetype)newGroupHostMessageFromExistingNewGroupHostMessage:(CMNewGroupHostMessage *)existingNewGroupHostMessage
{
  return [[[CMNewGroupHostMessageBuilder newGroupHostMessage]
           withGroupUuid:existingNewGroupHostMessage.groupUuid]
          withHostId:existingNewGroupHostMessage.hostId];
}

- (CMNewGroupHostMessage *)build
{
  return [[CMNewGroupHostMessage alloc] initWithGroupUuid:_groupUuid hostId:_hostId];
}

- (instancetype)withGroupUuid:(NSString *)groupUuid
{
  _groupUuid = [groupUuid copy];
  return self;
}

- (instancetype)withHostId:(NSString *)hostId
{
  _hostId = [hostId copy];
  return self;
}

@end

