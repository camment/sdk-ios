/**
 * This file is generated using the remodel generation script.
 * The name of the input file is Camment.value
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAsset.h>

@interface Camment : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *showUUID;
@property (nonatomic, readonly, copy) NSString *usersGroupUUID;
@property (nonatomic, readonly, copy) NSString *uuid;
@property (nonatomic, readonly, copy) NSString *remoteURL;
@property (nonatomic, readonly, copy) NSString *localURL;
@property (nonatomic, readonly, copy) AVAsset *localAsset;

- (instancetype)initWithShowUUID:(NSString *)showUUID usersGroupUUID:(NSString *)usersGroupUUID uuid:(NSString *)uuid remoteURL:(NSString *)remoteURL localURL:(NSString *)localURL localAsset:(AVAsset *)localAsset;

@end

