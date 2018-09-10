/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMAdBanner.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMAdBanner.h"

@implementation CMAdBanner

- (instancetype)initWithThumbnailURL:(NSString *)thumbnailURL videoURL:(NSString *)videoURL title:(NSString *)title openURL:(NSString *)openURL
{
  if ((self = [super init])) {
    _thumbnailURL = [thumbnailURL copy];
    _videoURL = [videoURL copy];
    _title = [title copy];
    _openURL = [openURL copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t thumbnailURL: %@; \n\t videoURL: %@; \n\t title: %@; \n\t openURL: %@; \n", [super description], _thumbnailURL, _videoURL, _title, _openURL];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_thumbnailURL hash], [_videoURL hash], [_title hash], [_openURL hash]};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 4; ++ii) {
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

- (BOOL)isEqual:(CMAdBanner *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_thumbnailURL == object->_thumbnailURL ? YES : [_thumbnailURL isEqual:object->_thumbnailURL]) &&
    (_videoURL == object->_videoURL ? YES : [_videoURL isEqual:object->_videoURL]) &&
    (_title == object->_title ? YES : [_title isEqual:object->_title]) &&
    (_openURL == object->_openURL ? YES : [_openURL isEqual:object->_openURL]);
}

@end

