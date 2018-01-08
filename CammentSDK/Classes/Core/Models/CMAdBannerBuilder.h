#import <Foundation/Foundation.h>

@class CMAdBanner;

@interface CMAdBannerBuilder : NSObject

+ (instancetype)adBanner;

+ (instancetype)adBannerFromExistingAdBanner:(CMAdBanner *)existingAdBanner;

- (CMAdBanner *)build;

- (instancetype)withThumbnailURL:(NSString *)thumbnailURL;

- (instancetype)withTitle:(NSString *)title;

- (instancetype)withOpenURL:(NSString *)openURL;

@end

