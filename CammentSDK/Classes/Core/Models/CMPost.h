/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMPost.value
 */

#import <Foundation/Foundation.h>
#import "CMUser.h"
#import "CMCamment.h"

@interface CMPost : NSObject <NSCopying>

@property (nonatomic, readonly) NSInteger postId;
@property (nonatomic, readonly, copy) NSString *uuid;
@property (nonatomic, readonly, copy) NSString *desc;
@property (nonatomic, readonly, copy) NSString *createdAt;
@property (nonatomic, readonly, copy) NSString *thumbnail;
@property (nonatomic, readonly, copy) NSArray<CMCamment* > *camments;
@property (nonatomic, readonly, copy) CMUser *user;
@property (nonatomic, readonly) BOOL liked;
@property (nonatomic, readonly) NSInteger totalLikes;
@property (nonatomic, readonly) NSInteger totalCamments;

- (instancetype)initWithPostId:(NSInteger)postId uuid:(NSString *)uuid desc:(NSString *)desc createdAt:(NSString *)createdAt thumbnail:(NSString *)thumbnail camments:(NSArray<CMCamment* > *)camments user:(CMUser *)user liked:(BOOL)liked totalLikes:(NSInteger)totalLikes totalCamments:(NSInteger)totalCamments;

@end

