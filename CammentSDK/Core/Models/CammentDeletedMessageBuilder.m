#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CammentDeletedMessage.h"
#import "CammentDeletedMessageBuilder.h"

@implementation CammentDeletedMessageBuilder
{
  Camment *_camment;
}

+ (instancetype)cammentDeletedMessage
{
  return [[CammentDeletedMessageBuilder alloc] init];
}

+ (instancetype)cammentDeletedMessageFromExistingCammentDeletedMessage:(CammentDeletedMessage *)existingCammentDeletedMessage
{
  return [[CammentDeletedMessageBuilder cammentDeletedMessage]
          withCamment:existingCammentDeletedMessage.camment];
}

- (CammentDeletedMessage *)build
{
  return [[CammentDeletedMessage alloc] initWithCamment:_camment];
}

- (instancetype)withCamment:(Camment *)camment
{
  _camment = [camment copy];
  return self;
}

@end

