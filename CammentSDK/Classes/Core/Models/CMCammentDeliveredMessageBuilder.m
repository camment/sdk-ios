#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMCammentDeliveredMessage.h"
#import "CMCammentDeliveredMessageBuilder.h"

@implementation CMCammentDeliveredMessageBuilder
{
  NSString *_cammentUuid;
}

+ (instancetype)cammentDeliveredMessage
{
  return [[CMCammentDeliveredMessageBuilder alloc] init];
}

+ (instancetype)cammentDeliveredMessageFromExistingCammentDeliveredMessage:(CMCammentDeliveredMessage *)existingCammentDeliveredMessage
{
  return [[CMCammentDeliveredMessageBuilder cammentDeliveredMessage]
          withCammentUuid:existingCammentDeliveredMessage.cammentUuid];
}

- (CMCammentDeliveredMessage *)build
{
  return [[CMCammentDeliveredMessage alloc] initWithCammentUuid:_cammentUuid];
}

- (instancetype)withCammentUuid:(NSString *)cammentUuid
{
  _cammentUuid = [cammentUuid copy];
  return self;
}

@end

