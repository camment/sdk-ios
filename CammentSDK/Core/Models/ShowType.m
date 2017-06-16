/**
 * This file is generated using the remodel generation script.
 * The name of the input file is ShowType.adtValue
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "ShowType.h"

typedef NS_ENUM(NSUInteger, _ShowTypeSubtypes) {
  _ShowTypeSubtypesvideo,
  _ShowTypeSubtypeshtml
};

@implementation ShowType
{
  _ShowTypeSubtypes _subtype;
  CMShow *_video_show;
  NSString *_html_webURL;
}

+ (instancetype)htmlWithWebURL:(NSString *)webURL
{
  ShowType *object = [[ShowType alloc] init];
  object->_subtype = _ShowTypeSubtypeshtml;
  object->_html_webURL = webURL;
  return object;
}

+ (instancetype)videoWithShow:(CMShow *)show
{
  ShowType *object = [[ShowType alloc] init];
  object->_subtype = _ShowTypeSubtypesvideo;
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
    case _ShowTypeSubtypesvideo: {
      return [NSString stringWithFormat:@"%@ - video \n\t show: %@; \n", [super description], _video_show];
      break;
    }
    case _ShowTypeSubtypeshtml: {
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

- (BOOL)isEqual:(ShowType *)object
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

- (void)matchVideo:(ShowTypeVideoMatchHandler)videoMatchHandler html:(ShowTypeHtmlMatchHandler)htmlMatchHandler
{
  switch (_subtype) {
    case _ShowTypeSubtypesvideo: {
      videoMatchHandler(_video_show);
      break;
    }
    case _ShowTypeSubtypeshtml: {
      htmlMatchHandler(_html_webURL);
      break;
    }
  }
}

@end

