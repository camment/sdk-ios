/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMUser.value
 */

#import <Foundation/Foundation.h>

@interface CMUser : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *cognitoUserId;
@property (nonatomic, readonly, copy) NSString *fbUserId;
@property (nonatomic, readonly, copy) NSString *username;
@property (nonatomic, readonly, copy) NSString *email;
@property (nonatomic, readonly, copy) NSString *userPhoto;
@property (nonatomic, readonly, copy) NSString *blockStatus;
@property (nonatomic, readonly, copy) NSString *onlineStatus;

- (instancetype)initWithCognitoUserId:(NSString *)cognitoUserId fbUserId:(NSString *)fbUserId username:(NSString *)username email:(NSString *)email userPhoto:(NSString *)userPhoto blockStatus:(NSString *)blockStatus onlineStatus:(NSString *)onlineStatus;

@end

