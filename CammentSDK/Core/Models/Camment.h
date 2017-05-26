/**
 * This file is generated using the remodel generation script.
 * The name of the input file is Camment.value
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAsset.h>

@interface Camment : NSObject <NSCopying>

@property (nonatomic, readonly) NSInteger cammentId;
@property (nonatomic, readonly, copy) NSString *remoteURL;
@property (nonatomic, readonly, copy) NSString *localURL;
@property (nonatomic, readonly, copy) AVAsset *localAsset;

- (instancetype)initWithCammentId:(NSInteger)cammentId remoteURL:(NSString *)remoteURL localURL:(NSString *)localURL localAsset:(AVAsset *)localAsset;

@end

