/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMAdBanner.value
 */

#import <Foundation/Foundation.h>

@interface CMAdBanner : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *thumbnailURL;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *openURL;

- (instancetype)initWithThumbnailURL:(NSString *)thumbnailURL title:(NSString *)title openURL:(NSString *)openURL;

@end

