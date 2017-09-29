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
#import "CMCammentAnonymousIdentity.h"
#import "CMCammentFacebookIdentity.h"
#import "CMCammentIdentity.h"
#import "CMCammentOverlayController.h"
#import "CMShowMetadata.h"
#import "CMInternalDefines.h"
#import "CMPublicModuleInterface.h"
#import "CMShowsListModule.h"

FOUNDATION_EXPORT double CammentSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char CammentSDKVersionString[];
