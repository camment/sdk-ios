#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMCammentDeletedMessage.h"
#import "CMCammentDeletedMessageBuilder.h"

@implementation CMCammentDeletedMessageBuilder
{
  CMCamment *_camment;
}

+ (instancetype)cammentDeletedMessage
{
  return [[CMCammentDeletedMessageBuilder alloc] init];
}

+ (instancetype)cammentDeletedMessageFromExistingCammentDeletedMessage:(CMCammentDeletedMessage *)existingCammentDeletedMessage
{
  return [[CMCammentDeletedMessageBuilder cammentDeletedMessage]
          withCamment:existingCammentDeletedMessage.camment];
}

- (CMCammentDeletedMessage *)build
{
  return [[CMCammentDeletedMessage alloc] initWithCamment:_camment];
}

- (instancetype)withCamment:(CMCamment *)camment
{
  _camment = [camment copy];
  return self;
}

@end

