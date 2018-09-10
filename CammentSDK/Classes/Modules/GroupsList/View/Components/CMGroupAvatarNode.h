//
//  CMGroupAvatarNode.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 31.05.2018.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface CMGroupAvatarNode: ASDisplayNode
- (instancetype)initWithImageUrls:(NSArray<NSString *> *)imageUrls;

+ (instancetype)nodeWithImageUrls:(NSArray<NSString *> *)imageUrls;


@end
