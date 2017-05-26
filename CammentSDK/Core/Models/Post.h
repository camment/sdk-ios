/**
 * This file is generated using the remodel generation script.
 * The name of the input file is Post.value
 */

#import <Foundation/Foundation.h>
#import "Camment.h"
#import "User.h"

@interface Post : NSObject <NSCopying>

@property (nonatomic, readonly) NSInteger postId;
@property (nonatomic, readonly, copy) NSString *uuid;
@property (nonatomic, readonly, copy) NSString *desc;
@property (nonatomic, readonly, copy) NSString *createdAt;
@property (nonatomic, readonly, copy) NSString *thumbnail;
@property (nonatomic, readonly, copy) NSArray<Camment* > *camments;
@property (nonatomic, readonly, copy) User *user;
@property (nonatomic, readonly) BOOL liked;
@property (nonatomic, readonly) NSInteger totalLikes;
@property (nonatomic, readonly) NSInteger totalCamments;

- (instancetype)initWithPostId:(NSInteger)postId uuid:(NSString *)uuid desc:(NSString *)desc createdAt:(NSString *)createdAt thumbnail:(NSString *)thumbnail camments:(NSArray<Camment* > *)camments user:(User *)user liked:(BOOL)liked totalLikes:(NSInteger)totalLikes totalCamments:(NSInteger)totalCamments;

@end

