#import <Foundation/Foundation.h>

@class CMCammentDeletedMessage;
@class CMCamment;

@interface CMCammentDeletedMessageBuilder : NSObject

+ (instancetype)cammentDeletedMessage;

+ (instancetype)cammentDeletedMessageFromExistingCammentDeletedMessage:(CMCammentDeletedMessage *)existingCammentDeletedMessage;

- (CMCammentDeletedMessage *)build;

- (instancetype)withCamment:(CMCamment *)camment;

@end

