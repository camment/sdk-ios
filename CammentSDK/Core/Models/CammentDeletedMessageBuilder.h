#import <Foundation/Foundation.h>

@class CammentDeletedMessage;
@class Camment;

@interface CammentDeletedMessageBuilder : NSObject

+ (instancetype)cammentDeletedMessage;

+ (instancetype)cammentDeletedMessageFromExistingCammentDeletedMessage:(CammentDeletedMessage *)existingCammentDeletedMessage;

- (CammentDeletedMessage *)build;

- (instancetype)withCamment:(Camment *)camment;

@end

