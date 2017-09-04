/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMUser.value
 */

#import <Foundation/Foundation.h>
#import "CMUserStatus.h"

@interface CMUser : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *userId;
@property (nonatomic, readonly, copy) NSString *cognitoUserId;
@property (nonatomic, readonly, copy) NSString *fbUserId;
@property (nonatomic, readonly, copy) NSString *username;
@property (nonatomic, readonly, copy) NSString *firstname;
@property (nonatomic, readonly, copy) NSString *lastname;
@property (nonatomic, readonly, copy) NSString *email;
@property (nonatomic, readonly, copy) NSString *visibility;
@property (nonatomic, readonly, copy) NSString *userPhoto;
@property (nonatomic, readonly) CMUserStatus status;

- (instancetype)initWithUserId:(NSString *)userId cognitoUserId:(NSString *)cognitoUserId fbUserId:(NSString *)fbUserId username:(NSString *)username firstname:(NSString *)firstname lastname:(NSString *)lastname email:(NSString *)email visibility:(NSString *)visibility userPhoto:(NSString *)userPhoto status:(CMUserStatus)status;

@end

