/**
 * This file is generated using the remodel generation script.
 * The name of the input file is UsersGroup.value
 */

#import <Foundation/Foundation.h>

@interface UsersGroup : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *uuid;
@property (nonatomic, readonly, copy) NSString *ownerCognitoUserId;
@property (nonatomic, readonly, copy) NSString *timestamp;

- (instancetype)initWithUuid:(NSString *)uuid ownerCognitoUserId:(NSString *)ownerCognitoUserId timestamp:(NSString *)timestamp;

@end

