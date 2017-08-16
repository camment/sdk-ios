/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMCammentsBlockItem.adtValue
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMCammentsBlockItem.h"

typedef NS_ENUM(NSUInteger, _CMCammentsBlockItemSubtypes) {
  _CMCammentsBlockItemSubtypescamment,
  _CMCammentsBlockItemSubtypesads
};

@implementation CMCammentsBlockItem
{
  _CMCammentsBlockItemSubtypes _subtype;
  CMCamment *_camment_camment;
  CMAds *_ads_ads;
}

+ (instancetype)adsWithAds:(CMAds *)ads
{
  CMCammentsBlockItem *object = [[CMCammentsBlockItem alloc] init];
  object->_subtype = _CMCammentsBlockItemSubtypesads;
  object->_ads_ads = ads;
  return object;
}

+ (instancetype)cammentWithCamment:(CMCamment *)camment
{
  CMCammentsBlockItem *object = [[CMCammentsBlockItem alloc] init];
  object->_subtype = _CMCammentsBlockItemSubtypescamment;
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
    case _CMCammentsBlockItemSubtypescamment: {
      return [NSString stringWithFormat:@"%@ - camment \n\t camment: %@; \n", [super description], _camment_camment];
      break;
    }
    case _CMCammentsBlockItemSubtypesads: {
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

- (BOOL)isEqual:(CMCammentsBlockItem *)object
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

- (void)matchCamment:(CMCammentsBlockItemCammentMatchHandler)cammentMatchHandler ads:(CMCammentsBlockItemAdsMatchHandler)adsMatchHandler
{
  switch (_subtype) {
    case _CMCammentsBlockItemSubtypescamment: {
      cammentMatchHandler(_camment_camment);
      break;
    }
    case _CMCammentsBlockItemSubtypesads: {
      adsMatchHandler(_ads_ads);
      break;
    }
  }
}

@end

