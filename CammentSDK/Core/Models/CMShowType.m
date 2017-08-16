/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMShowType.adtValue
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMShowType.h"

typedef NS_ENUM(NSUInteger, _CMShowTypeSubtypes) {
  _CMShowTypeSubtypesvideo,
  _CMShowTypeSubtypeshtml
};

@implementation CMShowType
{
  _CMShowTypeSubtypes _subtype;
  CMAPIShow *_video_show;
  NSString *_html_webURL;
}

+ (instancetype)htmlWithWebURL:(NSString *)webURL
{
  CMShowType *object = [[CMShowType alloc] init];
  object->_subtype = _CMShowTypeSubtypeshtml;
  object->_html_webURL = webURL;
  return object;
}

+ (instancetype)videoWithShow:(CMAPIShow *)show
{
  CMShowType *object = [[CMShowType alloc] init];
  object->_subtype = _CMShowTypeSubtypesvideo;
  object->_video_show = show;
  return object;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  switch (_subtype) {
    case _CMShowTypeSubtypesvideo: {
      return [NSString stringWithFormat:@"%@ - video \n\t show: %@; \n", [super description], _video_show];
      break;
    }
    case _CMShowTypeSubtypeshtml: {
      return [NSString stringWithFormat:@"%@ - html \n\t webURL: %@; \n", [super description], _html_webURL];
      break;
    }
  }
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {_subtype, [_video_show hash], [_html_webURL hash]};
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

- (BOOL)isEqual:(CMShowType *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    _subtype == object->_subtype &&
    (_video_show == object->_video_show ? YES : [_video_show isEqual:object->_video_show]) &&
    (_html_webURL == object->_html_webURL ? YES : [_html_webURL isEqual:object->_html_webURL]);
}

- (void)matchVideo:(CMShowTypeVideoMatchHandler)videoMatchHandler html:(CMShowTypeHtmlMatchHandler)htmlMatchHandler
{
  switch (_subtype) {
    case _CMShowTypeSubtypesvideo: {
      videoMatchHandler(_video_show);
      break;
    }
    case _CMShowTypeSubtypeshtml: {
      htmlMatchHandler(_html_webURL);
      break;
    }
  }
}

@end

