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
@class CMSofaInteractor;

@protocol CMSofaViewDelegate<NSObject>
- (void)sofaViewWantsToPresentViewController:(UIViewController *)viewController;
- (void)sofaViewDidClose;
@end

@interface CMSofaView : UIView

@property (nonatomic, strong) NSString *showUUID;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) CMCammentNode *influencerCammentNode;
@property (nonatomic, strong) CMSofaCameraPreviewView *cameraPreviewView;
@property (nonatomic, strong) CMSofaInviteFriendsView *inviteFriendsView;
@property (nonatomic, strong) UILabel *headerTextNode;
@property (nonatomic, strong) UILabel *enableCameraTextLabel;
@property (nonatomic, strong) UIImageView *enableCameraTextShadow;
@property (nonatomic, strong) UIButton *continueToShowButton;
@property (nonatomic, assign) CGFloat topInset;
@property (nonatomic, weak) id<CMSofaViewDelegate> delegate;
@property (nonatomic, strong) UITapGestureRecognizer *activateCameraGestureRecognizer;

@property(nonatomic, strong) CMCameraPreviewInteractor *recorder;
@property(nonatomic, strong) CMSofaInteractor *interactor;

- (void)cammentDidStop;

@end
