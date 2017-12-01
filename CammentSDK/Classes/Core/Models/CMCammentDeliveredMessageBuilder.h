#import <Foundation/Foundation.h>

@class CMCammentDeliveredMessage;

@interface CMCammentDeliveredMessageBuilder : NSObject

+ (instancetype)cammentDeliveredMessage;

+ (instancetype)cammentDeliveredMessageFromExistingCammentDeliveredMessage:(CMCammentDeliveredMessage *)existingCammentDeliveredMessage;

- (CMCammentDeliveredMessage *)build;

- (instancetype)withCammentUuid:(NSString *)cammentUuid;

@end

