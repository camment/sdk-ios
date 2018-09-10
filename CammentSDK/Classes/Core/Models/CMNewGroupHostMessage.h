/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMNewGroupHostMessage.value
 */

#import <Foundation/Foundation.h>

@interface CMNewGroupHostMessage : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *groupUuid;
@property (nonatomic, readonly, copy) NSString *hostId;

- (instancetype)initWithGroupUuid:(NSString *)groupUuid hostId:(NSString *)hostId;

@end

