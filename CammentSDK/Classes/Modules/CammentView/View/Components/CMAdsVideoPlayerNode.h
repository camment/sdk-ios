//
// Created by Alexander Fedosov on 27.10.2017.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMVideoAd;

@protocol CMAdsVideoPlayerNodeDelegate<NSObject>

- (void)cmAdsVideoPlayerNodeDidClose;

@end

@interface CMAdsVideoPlayerNode : ASDisplayNode

@property(nonatomic, weak) id<CMAdsVideoPlayerNodeDelegate> delegate;

@property(nonatomic, strong) CMVideoAd *videoAd;
@property(nonatomic, strong) ASVideoNode *videoPlayerNode;
@property(nonatomic, strong) ASButtonNode *openLinkButton;

@property(nonatomic, strong) ASButtonNode *closeButtonNode;

- (void)play:(CMVideoAd *)videoAd;
@end