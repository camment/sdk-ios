/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CammentsBlockItem.adtValue
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CammentsBlockItem.h"

typedef NS_ENUM(NSUInteger, _CammentsBlockItemSubtypes) {
  _CammentsBlockItemSubtypescamment,
  _CammentsBlockItemSubtypesads
};

@implementation CammentsBlockItem
{
  _CammentsBlockItemSubtypes _subtype;
  Camment *_camment_camment;
  Ads *_ads_ads;
}

+ (instancetype)adsWithAds:(Ads *)ads
{
  CammentsBlockItem *object = [[CammentsBlockItem alloc] init];
  object->_subtype = _CammentsBlockItemSubtypesads;
  object->_ads_ads = ads;
  return object;
}

+ (instancetype)cammentWithCamment:(Camment *)camment
{
  CammentsBlockItem *object = [[CammentsBlockItem alloc] init];
  object->_subtype = _CammentsBlockItemSubtypescamment;
  object->_camment_camment = camment;
  return object;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  switch (_subtype) {
    case _CammentsBlockItemSubtypescamment: {
      return [NSString stringWithFormat:@"%@ - camment \n\t camment: %@; \n", [super description], _camment_camment];
      break;
    }
    case _CammentsBlockItemSubtypesads: {
      return [NSString stringWithFormat:@"%@ - ads \n\t ads: %@; \n", [super description], _ads_ads];
      break;
    }
  }
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {_subtype, [_camment_camment hash], [_ads_ads hash]};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 3; ++ii) {
    unsigned long long base = (((unsigned long long)result) << 32 | subhashes[ii]);
    base = (~base) + (base << 18);
    base ^= (base >> 31);
    base *=  21;
    base ^= (base >> 11);
    base += (base << 6);
    base ^= (base >> 22);
    result = base;
  }
  return result;
}

- (BOOL)isEqual:(CammentsBlockItem *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    _subtype == object->_subtype &&
    (_camment_camment == object->_camment_camment ? YES : [_camment_camment isEqual:object->_camment_camment]) &&
    (_ads_ads == object->_ads_ads ? YES : [_ads_ads isEqual:object->_ads_ads]);
}

- (void)matchCamment:(CammentsBlockItemCammentMatchHandler)cammentMatchHandler ads:(CammentsBlockItemAdsMatchHandler)adsMatchHandler
{
  switch (_subtype) {
    case _CammentsBlockItemSubtypescamment: {
      cammentMatchHandler(_camment_camment);
      break;
    }
    case _CammentsBlockItemSubtypesads: {
      adsMatchHandler(_ads_ads);
      break;
    }
  }
}

@end

