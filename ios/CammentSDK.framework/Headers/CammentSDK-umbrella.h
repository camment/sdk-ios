#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CammentSDK.h"
#import "CMCammentOverlayController.h"
#import "CMCammentOverlayLayoutConfig.h"
#import "CMIdentityProvider.h"
#import "CMShowMetadata.h"
#import "CMFacebookIdentityProvider.h"

FOUNDATION_EXPORT double CammentSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char CammentSDKVersionString[];

