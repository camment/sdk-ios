#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMAdBanner.h"
#import "CMAdBannerBuilder.h"

@implementation CMAdBannerBuilder
{
  NSString *_thumbnailURL;
  NSString *_title;
  NSString *_openURL;
}

+ (instancetype)adBanner
{
  return [[CMAdBannerBuilder alloc] init];
}

+ (instancetype)adBannerFromExistingAdBanner:(CMAdBanner *)existingAdBanner
{
  return [[[[CMAdBannerBuilder adBanner]
            withThumbnailURL:existingAdBanner.thumbnailURL]
           withTitle:existingAdBanner.title]
          withOpenURL:existingAdBanner.openURL];
}

- (CMAdBanner *)build
{
  return [[CMAdBanner alloc] initWithThumbnailURL:_thumbnailURL title:_title openURL:_openURL];
}

- (instancetype)withThumbnailURL:(NSString *)thumbnailURL
{
  _thumbnailURL = [thumbnailURL copy];
  return self;
}

- (instancetype)withTitle:(NSString *)title
{
  _title = [title copy];
  return self;
}

- (instancetype)withOpenURL:(NSString *)openURL
{
  _openURL = [openURL copy];
  return self;
}

@end

