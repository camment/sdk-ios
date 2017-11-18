//
//  Prefix.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 30.05.17.
//  Copyright © 2017 Camment. All rights reserved.
//

#ifndef Prefix_h
#define Prefix_h

#ifdef __OBJC__

#define LOG_LEVEL_DEF ddLogLevel
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "NSBundle+CammentSDK.h"

#define DDLogDeveloperInfo(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, (1 << 10),    0, nil, __PRETTY_FUNCTION__, [@"[CammentSDK]: " stringByAppendingString:frmt],##__VA_ARGS__)

#ifdef DEBUG
static const NSUInteger ddLogLevel = DDLogLevelAll;
#else
static const NSUInteger ddLogLevel = DDLogLevelError | (1 << 10);
#endif

#ifdef POD_CONFIGURATION_BETA
    #define INTERNALSDK
    #define INTERNALBUILD
    static const NSString *CMSDKEnvironment = @"beta";
#endif

#ifdef POD_CONFIGURATION_DEBUG
    #define INTERNALSDK
    #define INTERNALBUILD
    static const NSString *CMSDKEnvironment = @"debug";
#endif

#ifdef POD_CONFIGURATION_RELEASE
    static const NSString *CMSDKEnvironment = @"production";
#endif

#ifdef INTERNALSDK
    #define USE_INTERNAL_FEATURES
#endif


@class CammentSDK;

#define CMLocalized(str) NSLocalizedStringFromTableInBundle(str, @"CammentSDK", [NSBundle cammentSDKBundle], @"")

#endif
#endif /* Prefix_h */
