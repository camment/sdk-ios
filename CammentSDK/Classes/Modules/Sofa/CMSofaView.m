//
//  CMSofaView.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 17/08/2018.
//
#import <AVFoundation/AVFoundation.h>
#import <AsyncDisplayKit/ASTextNode.h>
#import <Bolts/Bolts.h>
#import "CMSofaView.h"
#import "CMCammentNode.h"
#import "CMCamment.h"
#import "CMSofaCameraPreviewView.h"
#import "CMSofaInviteFriendsView.h"
#import "CMCammentRecorderInteractor.h"
#import "CMTouchTransparentView.h"
#import "CMCameraPreviewInteractor.h"
#import "UIFont+CammentFonts.h"
#import "CMOpenURLHelper.h"
#import "CMSofaInteractor.h"
#import "UIColorMacros.h"
#import "CMSofaInvitationInteractor.h"
#import "CMErrorWireframe.h"

@interface CMSofaView() <CMSofaInteractorOutput>
@end


@implementation CMSofaView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sofa_bg"
                                                                                 inBundle:[NSBundle cammentSDKBundle]
                                                            compatibleWithTraitCollection:nil]];
        self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.backgroundImageView];

        self.enableCameraTextShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_text_shadow_rect"
                                                                                    inBundle:[NSBundle cammentSDKBundle]
                                                               compatibleWithTraitCollection:nil]];
        self.enableCameraTextShadow.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.enableCameraTextShadow];

        self.enableCameraTextLabel = [[UILabel alloc] init];
        self.enableCameraTextLabel.textColor = [UIColor whiteColor];
        self.enableCameraTextLabel.text = CMLocalized(@"sofaview.tap_to_enable_camera");
        self.enableCameraTextLabel.textAlignment = NSTextAlignmentCenter;
        self.enableCameraTextLabel.adjustsFontSizeToFitWidth = YES;
        self.enableCameraTextLabel.minimumScaleFactor = 11.0f / 18.0f;
        self.enableCameraTextLabel.font = [UIFont nunitoLightWithSize:18.0f];
        self.enableCameraTextLabel.numberOfLines = 0;
        self.enableCameraTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.enableCameraTextLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        self.enableCameraTextLabel.layer.shadowOffset = CGSizeMake(.0f, .0f);
        self.enableCameraTextLabel.layer.shadowOpacity = .8f;
        self.enableCameraTextLabel.layer.shadowRadius = 20.0f;
        self.enableCameraTextLabel.layer.masksToBounds = NO;
        [self addSubview:self.enableCameraTextLabel];

        self.cameraPreviewView = [CMSofaCameraPreviewView new];
        self.activateCameraGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOnActivateCamera:)];
        [self.activateCameraGestureRecognizer setEnabled:NO];
        [self.cameraPreviewView addGestureRecognizer:self.activateCameraGestureRecognizer];
        [self.cameraPreviewView setUserInteractionEnabled:YES];
        [self addSubview:self.cameraPreviewView];

        self.inviteFriendsView = [CMSofaInviteFriendsView new];
        __weak typeof(self) __weakSelf = self;
        self.inviteFriendsView.onInviteAction = ^{
            [__weakSelf inviteFriends];
        };

        [self addSubview:self.inviteFriendsView];

        self.headerTextNode = [[UILabel alloc] init];
        self.headerTextNode.textColor = [UIColor whiteColor];
        self.headerTextNode.text = @"Enjoy the show with Brian and Samsung. Invite a friend to your virtual couch and WIN prices!";
        self.headerTextNode.textAlignment = NSTextAlignmentCenter;
        self.headerTextNode.adjustsFontSizeToFitWidth = YES;
        self.headerTextNode.minimumScaleFactor = 8.0f / 36.0f;
        self.headerTextNode.font = [UIFont systemFontOfSize:36.0f];
        self.headerTextNode.numberOfLines = 0;
        self.headerTextNode.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.headerTextNode];

        self.continueToShowButton = [[UIButton alloc] init];
        [self.continueToShowButton.titleLabel setFont:[UIFont nunitoLightWithSize:16]];
        [self.continueToShowButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        self.continueToShowButton.layer.masksToBounds = YES;
        self.continueToShowButton.titleEdgeInsets = UIEdgeInsetsMake(5.0f, 15.0f, 5.0f, 15.0f);
        [self.continueToShowButton setTitle:CMLocalized(@"sofaview.button.continue_to_show")
                                   forState:UIControlStateNormal];
        [self.continueToShowButton addTarget:self
                                      action:@selector(handleCloseSofaViewEvent:)
                            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.continueToShowButton];

        self.dimView = [CMTouchTransparentView new];
        self.dimView.backgroundColor = [UIColor blackColor];
        self.dimView.alpha = .0f;
        [self addSubview:self.dimView];

        self.influencerCammentNode = [CMCammentNode new];
        self.influencerCammentNode.onStoppedPlaying = ^{
            [__weakSelf cammentDidStop];
        };
        self.influencerCammentNode.style.width = ASDimensionMake(90);
        self.influencerCammentNode.style.height = ASDimensionMake(90);
        NSString *remoteURL = @"https://d17vsv1e5spnkm.cloudfront.net/uploads/01d1c040-3c60-4e03-8f5b-c5c86da7a882.mp4";
        self.influencerCammentNode.camment = [[CMCamment alloc] initWithShowUuid:@""
                                                                   userGroupUuid:@""
                                                                            uuid:@""
                                                                       remoteURL:remoteURL
                                                                        localURL:@""
                                                                    thumbnailURL:@""
                                                           userCognitoIdentityId:@""
                                                                          showAt:@0
                                                                     isMadeByBot:NO
                                                                         botUuid:nil
                                                                       botAction:nil
                                                                       isDeleted:NO
                                                                 shouldBeDeleted:NO
                                                                          status:[CMCammentStatus new]];
        [self.influencerCammentNode setDisplaysAsynchronously:NO];

        UIGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnCamment:)];
        [self.influencerCammentNode.view addGestureRecognizer:gestureRecognizer];
        [self.influencerCammentNode.view setUserInteractionEnabled:YES];

        [self addSubview:self.influencerCammentNode.view];

        self.recorder = [CMCameraPreviewInteractor new];

        [self.interactor fetchSofaViewForShow:@"test_show_uuid"];

        self.clipsToBounds = YES;
    }

    return self;
}

- (void)inviteFriends {
    [[self.interactor.invitationInteractor inviteFriends] continueWithExecutor:[BFExecutor mainThreadExecutor]
                                                                     withBlock:^id(BFTask <NSString *> *task) {
                                                                         if (task.error) {
                                                                             if ([self.delegate respondsToSelector:@selector(sofaViewWantsToPresentViewController:)]) {
                                                                                 [self.delegate sofaViewWantsToPresentViewController:[[CMErrorWireframe new] viewControllerDisplayingError:task.error]];
                                                                             }
                                                                         } else {
                                                                             [self showShareDeeplinkDialog:task.result];
                                                                         }
                                                                         return nil;
                                                                     }];
}

- (void)handleCloseSofaViewEvent:(UIButton *)continueToShowButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sofaViewDidClose)]) {
        [self.delegate sofaViewDidClose];
    }
}

- (void)handleOnActivateCamera:(UITapGestureRecognizer *)gestureRecognizer {

    AVAuthorizationStatus cameraPermissions = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    AVAuthorizationStatus microphonePermissions = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];

    BOOL cameraDenied = cameraPermissions == AVAuthorizationStatusDenied || cameraPermissions == AVAuthorizationStatusRestricted;
    BOOL microphoneDenied = microphonePermissions == AVAuthorizationStatusDenied || microphonePermissions == AVAuthorizationStatusRestricted;

    if (cameraDenied || microphoneDenied) {
        [self showAllowCameraPermissionsView];
    } else {
        [self askCameraPermissions];
    }
}

- (void)didMoveToSuperview {
    if (self.superview == nil) {
        return;
    }

    [self checkCameraPermissions];
}

- (void)dealloc {
    [self.recorder releaseCamera];
}

- (void)checkCameraPermissions {

    AVAuthorizationStatus cameraAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    AVAuthorizationStatus micAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];

    if(cameraAuthStatus == AVAuthorizationStatusAuthorized && micAuthStatus == AVAuthorizationStatusAuthorized) {
        [self setCameraPermissionsGrantedState];
    } else if(cameraAuthStatus == AVAuthorizationStatusDenied || micAuthStatus == AVAuthorizationStatusDenied){
        [self setCameraPermissionsDeniedState];
    } else if(cameraAuthStatus == AVAuthorizationStatusRestricted  || micAuthStatus == AVAuthorizationStatusRestricted){
        [self setCameraPermissionsDeniedState];
    } else {
        [self setCameraPermissionsNotDeterminedState];
    }
}

- (void)askCameraPermissions {
    [self.activateCameraGestureRecognizer setEnabled:NO];

    [[[self.recorder requestPermissionsForMediaTypeIfNeeded:AVMediaTypeVideo]
            continueWithSuccessBlock:^id(BFTask <AVMediaType> *task) {
                return [self.recorder requestPermissionsForMediaTypeIfNeeded:AVMediaTypeAudio];
            }]
            continueWithExecutor:[BFExecutor mainThreadExecutor]
                       withBlock:^id(BFTask <AVMediaType> *t) {
                           if (!t.error) {
                               [self setCameraPermissionsGrantedState];
                           } else {
                               [self setCameraPermissionsDeniedState];
                           }
                           return nil;
                       }];
}

- (void)setCameraPermissionsNotDeterminedState{
    self.enableCameraTextLabel.hidden = NO;
    self.enableCameraTextShadow.hidden = NO;
    [self.cameraPreviewView setPermissionsNotDeterminedState];
    [self.activateCameraGestureRecognizer setEnabled:YES];
}

- (void)setCameraPermissionsGrantedState {
    self.enableCameraTextLabel.hidden = YES;
    self.enableCameraTextShadow.hidden = YES;
    [self.cameraPreviewView setPermissionsGrantedState];
    [self.activateCameraGestureRecognizer setEnabled:NO];
    [self.recorder configureCamera];
    [self.recorder connectPreviewViewToRecorder:self.cameraPreviewView.imageView];
}

- (void)setCameraPermissionsDeniedState {
    self.enableCameraTextLabel.hidden = YES;
    self.enableCameraTextShadow.hidden = YES;
    [self.cameraPreviewView setPermissionsDeniedState];
    [self.activateCameraGestureRecognizer setEnabled:YES];
}

- (void)cammentDidStop {
    [UIView animateWithDuration:.3f
                     animations:^{
                         self.dimView.alpha = .0f;
                     }];
}

- (void)handleTapOnCamment:(UITapGestureRecognizer *)gestureRecognizer {
    if ([self.influencerCammentNode isPlaying]) {
        [self.influencerCammentNode stopCamment];
        [self cammentDidStop];
    } else {
        [self.influencerCammentNode playCamment];
        [UIView animateWithDuration:.3f
                         animations:^{
                             self.dimView.alpha = .6f;
                         }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.dimView.frame = self.bounds;

    self.backgroundImageView.frame = [self frameToFitInternalRect:CGRectMake(571, 680, 453, 278) toScreenRect:CGRectMake(.0f, self.bounds.size.height / 4, self.bounds.size.width, self.bounds.size.height / 2)];

    self.influencerCammentNode.view.frame = [self convertOriginalRect:CGRectMake(637, 689, 80, 80)
                                                        toScaledImage:self.backgroundImageView.frame];

    self.cameraPreviewView.frame = [self convertOriginalRect:CGRectMake(760, 689, 80, 80)
                                               toScaledImage:self.backgroundImageView.frame];

    self.inviteFriendsView.frame = [self convertOriginalRect:CGRectMake(880, 689, 80, 80)
                                               toScaledImage:self.backgroundImageView.frame];
    self.inviteFriendsView.layer.cornerRadius = ceilf(self.inviteFriendsView.frame.size.width / 2);

    CGFloat margin = 20.0f;

    CGFloat availableHeight = CGRectGetMinY(self.influencerCammentNode.view.frame) - margin * 2 - _topInset;
    CGSize headerSize = [self.headerTextNode sizeThatFits:CGSizeMake(self.bounds.size.width - margin * 2, availableHeight)];

    self.headerTextNode.frame = CGRectMake(
            (self.bounds.size.width - headerSize.width) / 2,
            CGRectGetMinY(self.influencerCammentNode.view.frame)/ 2 - MIN(headerSize.height, availableHeight) / 2,
            headerSize.width,
            MIN(headerSize.height, availableHeight));

    CGFloat availableWidthForCameraText = CGRectGetMaxX(self.inviteFriendsView.frame) - CGRectGetMinX(self.influencerCammentNode.view.frame);
    CGSize enableCameraTextSize = [self.enableCameraTextLabel sizeThatFits:CGSizeMake(availableWidthForCameraText, CGFLOAT_MAX)];
    self.enableCameraTextLabel.frame = CGRectMake(
            self.center.x - enableCameraTextSize.width / 2,
            CGRectGetMaxY(self.cameraPreviewView.frame) + 14,
            enableCameraTextSize.width,
            MIN(enableCameraTextSize.height, (self.bounds.size.height - CGRectGetMaxY(self.inviteFriendsView.frame)) / 2 - 14));
    self.enableCameraTextShadow.frame = CGRectInset(self.enableCameraTextLabel.frame, -50, -50);
    self.enableCameraTextShadow.center = CGPointMake(self.enableCameraTextLabel.center.x, self.enableCameraTextLabel.center.y + 10.0f);

    CGSize buttonSize = [self.continueToShowButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    buttonSize = CGSizeMake(
            buttonSize.width + self.continueToShowButton.titleEdgeInsets.left + self.continueToShowButton.titleEdgeInsets.right,
            buttonSize.height + self.continueToShowButton.titleEdgeInsets.top + self.continueToShowButton.titleEdgeInsets.bottom);
    self.continueToShowButton.frame = CGRectMake(
            self.bounds.size.width - margin - buttonSize.width,
            self.bounds.size.height - margin - buttonSize.height,
            buttonSize.width,
            buttonSize.height);
    self.continueToShowButton.layer.cornerRadius = self.continueToShowButton.bounds.size.height / 2.0f;
}

// Returns frame for image calculated in a way that "rect" stays always visible at the screen
- (CGRect)frameToFitInternalRect:(CGRect)rect toScreenRect:(CGRect)screenRect {

    //Calculate scale factor needed to fit rect into screen bounds
    //Fit width first
    CGFloat s = CGRectGetWidth(screenRect) / CGRectGetWidth(rect);

    //If height doesn't fit with current scale factor we fix that
    if (CGRectGetHeight(rect) * s > CGRectGetHeight(screenRect)) {
        s = CGRectGetHeight(screenRect) / CGRectGetHeight(rect);
    }

    // Make sure we never scale image up, scaling down is fine
    if (s > 1) { s = 1; }

    NSLog(@"scale factor %f", s);

    //Scale provided rect
    CGRect scaledRect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale(s, s));

    //Scale original image
    CGSize imageSize = CGSizeApplyAffineTransform(self.backgroundImageView.image.size, CGAffineTransformMakeScale(s, s));

    //Construct a new frame for scaled image, image aligned to the left top corner of a screen
    CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);

    //Move image on the screen to make provided rect visible
    imageRect = CGRectApplyAffineTransform(
            imageRect,
            CGAffineTransformMakeTranslation(CGRectGetMidX(screenRect) - CGRectGetMidX(scaledRect),
                    CGRectGetMidY(screenRect) - CGRectGetMidY(scaledRect)));

    return imageRect;
}

- (CGRect)convertOriginalRect:(CGRect)originalRect toScaledImage:(CGRect)imageRect {

    //Get scale factor
    CGFloat s = imageRect.size.width / self.backgroundImageView.image.size.width;

    CGRect result = CGRectApplyAffineTransform(originalRect, CGAffineTransformMakeScale(s, s));

    result =  CGRectApplyAffineTransform(result, CGAffineTransformMakeTranslation(imageRect.origin.x, imageRect.origin.y));

    return result;
}

- (void)showAllowCameraPermissionsView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:CMLocalized(@"error.no_camera_permissions_title")]
                                                                             message:CMLocalized(@"error.no_camera_permissions_alert")
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"setup.maybe_later")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {}]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"error.open_settings")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                          [[CMOpenURLHelper new] openURL:settingsURL];
                                                      }]];
    [self.delegate sofaViewWantsToPresentViewController:alertController];
}

- (void)showShareDeeplinkDialog:(NSString *)link {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:CMLocalized(@"Send the invitation link")]
                                                                             message:CMLocalized(@"Invite users by sharing the invitation link via channel of your choice")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *textToShare = @"";
        NSURL *url = [NSURL URLWithString:link];

        NSString *shareString = [NSString stringWithFormat:@"%@ %@", textToShare, url.absoluteString];
        NSArray *objectsToShare = @[shareString];

        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare
                                                                                 applicationActivities:nil];

        activityVC.popoverPresentationController.sourceView = self;
        [self.delegate sofaViewWantsToPresentViewController:activityVC];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"cancel")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                      }]];

    [self.delegate sofaViewWantsToPresentViewController:alertController];
}
- (void)sofaViewDidFetchedContent:(CMAPISofa *)sofa {

}

- (void)sofaViewDidFailedFetching:(NSError *)error {

}

@end
