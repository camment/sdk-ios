/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMUserOnlineStatusChangedMessage.value
 */

#import <Foundation/Foundation.h>

@interface CMUserOnlineStatusChangedMessage : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *userId;
@property (nonatomic, readonly, copy) NSString *status;

- (instancetype)initWithUserId:(NSString *)userId status:(NSString *)status;

@end

