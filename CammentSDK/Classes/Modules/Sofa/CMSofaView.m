//
//  CMSofaView.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 17/08/2018.
//
#import <AVFoundation/AVFoundation.h>
#import <AsyncDisplayKit/ASTextNode.h>
#import "CMSofaView.h"
#import "CMCammentNode.h"
#import "CMCamment.h"
#import "CMSofaCameraPreviewView.h"
#import "CMSofaInviteFriendsView.h"
#import "CMCammentRecorderInteractor.h"
#import "CMTouchTransparentView.h"
#import "CMCameraPreviewInteractor.h"
#import "UIFont+CammentFonts.h"

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
        self.enableCameraTextLabel.text = @"Tap Camera icon to enable camera";
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
        [self addSubview:self.inviteFriendsView];

        self.headerTextNode = [[UILabel alloc] init];
        self.headerTextNode.textColor = [UIColor blackColor];
        self.headerTextNode.text = @"When user enters the sofa view and camera / microphone has no permissions - notification is displayed to tap camera icon to enable camera and microphone with standard procedure.";
        self.headerTextNode.textAlignment = NSTextAlignmentCenter;
        self.headerTextNode.adjustsFontSizeToFitWidth = YES;
        self.headerTextNode.minimumScaleFactor = 12.0f / 48.0f;
        self.headerTextNode.font = [UIFont systemFontOfSize:48];
        self.headerTextNode.numberOfLines = 0;
        self.headerTextNode.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.headerTextNode];

        self.dimView = [CMTouchTransparentView new];
        self.dimView.backgroundColor = [UIColor blackColor];
        self.dimView.alpha = .0f;
        [self addSubview:self.dimView];

        self.influencerCammentNode = [CMCammentNode new];
        __weak typeof(self) __weakSelf = self;
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
    }

    return self;
}

- (void)handleOnActivateCamera:(UITapGestureRecognizer *)gestureRecognizer {
    [self askCameraPermissions];
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

    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        [self setCameraPermissionsGrantedState];
    } else if(authStatus == AVAuthorizationStatusDenied){
        [self setCameraPermissionsDeniedState];
    } else if(authStatus == AVAuthorizationStatusRestricted){
        // restricted, normally won't happen
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        [self setCameraPermissionsNotDeterminedState];
    }

}

- (void)askCameraPermissions {
    [self.activateCameraGestureRecognizer setEnabled:NO];
    NSString *mediaType = AVMediaTypeVideo;
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(granted){
                NSLog(@"Granted access to %@", mediaType);
                [self setCameraPermissionsGrantedState];
            } else {
                NSLog(@"Not granted access to %@", mediaType);
                [self setCameraPermissionsDeniedState];
            }
        });
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

    self.backgroundImageView.frame = [self frameToFitInternalRect:CGRectMake(238, 498, 858, 484) toScreenRect:CGRectMake(.0f, self.bounds.size.height / 4, self.bounds.size.width, self.bounds.size.height / 2)];

    self.influencerCammentNode.view.frame = [self convertOriginalRect:CGRectMake(362, 533, 160, 160)
                                                        toScaledImage:self.backgroundImageView.frame];

    self.cameraPreviewView.frame = [self convertOriginalRect:CGRectMake(592, 533, 160, 160)
                                               toScaledImage:self.backgroundImageView.frame];

    self.inviteFriendsView.frame = [self convertOriginalRect:CGRectMake(792, 533, 160, 160)
                                               toScaledImage:self.backgroundImageView.frame];
    self.inviteFriendsView.layer.cornerRadius = ceilf(self.inviteFriendsView.frame.size.width / 2);

    CGFloat margin = 30.0f;

    CGFloat availableHeight = CGRectGetMinY(self.influencerCammentNode.view.frame) - margin * 2 - _topInset;
    CGSize headerSize = [self.headerTextNode sizeThatFits:CGSizeMake(self.bounds.size.width - margin * 2, availableHeight)];

    self.headerTextNode.frame = CGRectMake(
            (self.bounds.size.width - headerSize.width) / 2,
            CGRectGetMinY(self.influencerCammentNode.view.frame) - margin - MIN(headerSize.height, availableHeight),
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

@end
