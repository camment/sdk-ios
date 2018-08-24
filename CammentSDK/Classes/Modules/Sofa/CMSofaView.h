//
//  CMSofaView.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 17/08/2018.
//

#import <UIKit/UIKit.h>

@class CMCammentNode;
@class ASTextNode;
@class CMSofaCameraPreviewView;
@class CMSofaInviteFriendsView;
@class CMCameraPreviewInteractor;

@protocol CMSofaViewDelegate<NSObject>
- (void)sofaViewWantsToPresentViewController:(UIViewController *)viewController;
@end

@interface CMSofaView : UIView

@property(nonatomic, strong) UIImageView *backgroundImageView;
@property(nonatomic, strong) UIView *dimView;
@property(nonatomic, strong) CMCammentNode *influencerCammentNode;
@property(nonatomic, strong) CMSofaCameraPreviewView *cameraPreviewView;
@property(nonatomic, strong) CMSofaInviteFriendsView *inviteFriendsView;
@property(nonatomic, strong) UILabel *headerTextNode;
@property(nonatomic, strong) UILabel *enableCameraTextLabel;
@property(nonatomic, strong) UIImageView *enableCameraTextShadow;
@property(nonatomic, assign) CGFloat topInset;
@property(nonatomic, strong) CMCameraPreviewInteractor *recorder;
@property(nonatomic, weak) id<CMSofaViewDelegate> delegate;

@property(nonatomic, strong) UITapGestureRecognizer *activateCameraGestureRecognizer;

- (void)cammentDidStop;

@end
