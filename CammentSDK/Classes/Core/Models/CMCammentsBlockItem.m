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
  _CMCammentsBlockItemSubtypesbotCamment
};

@implementation CMCammentsBlockItem
{
  _CMCammentsBlockItemSubtypes _subtype;
  CMCamment *_camment_camment;
  CMBotCamment *_botCamment_botCamment;
}

+ (instancetype)botCammentWithBotCamment:(CMBotCamment *)botCamment
{
  CMCammentsBlockItem *object = [[CMCammentsBlockItem alloc] init];
  object->_subtype = _CMCammentsBlockItemSubtypesbotCamment;
  object->_botCamment_botCamment = botCamment;
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
    case _CMCammentsBlockItemSubtypesbotCamment: {
      return [NSString stringWithFormat:@"%@ - botCamment \n\t botCamment: %@; \n", [super description], _botCamment_botCamment];
      break;
    }
  }
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {_subtype, [_camment_camment hash], [_botCamment_botCamment hash]};
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
    (_botCamment_botCamment == object->_botCamment_botCamment ? YES : [_botCamment_botCamment isEqual:object->_botCamment_botCamment]);
}

- (void)matchCamment:(CMCammentsBlockItemCammentMatchHandler)cammentMatchHandler botCamment:(CMCammentsBlockItemBotCammentMatchHandler)botCammentMatchHandler
{
  switch (_subtype) {
    case _CMCammentsBlockItemSubtypescamment: {
      cammentMatchHandler(_camment_camment);
      break;
    }
    case _CMCammentsBlockItemSubtypesbotCamment: {
      botCammentMatchHandler(_botCamment_botCamment);
      break;
    }
  }
}

@end

