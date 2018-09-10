#import <Foundation/Foundation.h>

@class CMNewGroupHostMessage;

@interface CMNewGroupHostMessageBuilder : NSObject

+ (instancetype)newGroupHostMessage;

+ (instancetype)newGroupHostMessageFromExistingNewGroupHostMessage:(CMNewGroupHostMessage *)existingNewGroupHostMessage;

- (CMNewGroupHostMessage *)build;

- (instancetype)withGroupUuid:(NSString *)groupUuid;

- (instancetype)withHostId:(NSString *)hostId;

@end

