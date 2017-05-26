/**
 * This file is generated using the remodel generation script.
 * The name of the input file is User.value
 */

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCopying>

@property (nonatomic, readonly) NSInteger userId;
@property (nonatomic, readonly, copy) NSString *username;
@property (nonatomic, readonly, copy) NSString *firstname;
@property (nonatomic, readonly, copy) NSString *lastname;
@property (nonatomic, readonly, copy) NSString *email;
@property (nonatomic, readonly, copy) NSString *visibility;

- (instancetype)initWithUserId:(NSInteger)userId username:(NSString *)username firstname:(NSString *)firstname lastname:(NSString *)lastname email:(NSString *)email visibility:(NSString *)visibility;

@end

