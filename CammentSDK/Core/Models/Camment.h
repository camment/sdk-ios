/**
 * This file is generated using the remodel generation script.
 * The name of the input file is Camment.value
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAsset.h>

@interface Camment : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *showUUID;
@property (nonatomic, readonly, copy) NSString *cammentUUID;
@property (nonatomic, readonly, copy) NSString *remoteURL;
@property (nonatomic, readonly, copy) NSString *localURL;
@property (nonatomic, readonly, copy) AVAsset *localAsset;
@property (nonatomic, readonly, copy) NSString *temporaryUUID;

- (instancetype)initWithShowUUID:(NSString *)showUUID cammentUUID:(NSString *)cammentUUID remoteURL:(NSString *)remoteURL localURL:(NSString *)localURL localAsset:(AVAsset *)localAsset temporaryUUID:(NSString *)temporaryUUID;

@end

