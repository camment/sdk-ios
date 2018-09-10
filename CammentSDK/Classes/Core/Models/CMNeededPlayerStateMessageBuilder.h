#import <Foundation/Foundation.h>

@class CMNeededPlayerStateMessage;

@interface CMNeededPlayerStateMessageBuilder : NSObject

+ (instancetype)neededPlayerStateMessage;

+ (instancetype)neededPlayerStateMessageFromExistingNeededPlayerStateMessage:(CMNeededPlayerStateMessage *)existingNeededPlayerStateMessage;

- (CMNeededPlayerStateMessage *)build;

- (instancetype)withGroupUUID:(NSString *)groupUUID;

@end

