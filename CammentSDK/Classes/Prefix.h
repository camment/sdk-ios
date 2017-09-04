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

#ifdef DEBUG
    static const DDLogLevel ddLogLevel = DDLogLevelAll;
#else
    static const DDLogLevel ddLogLevel = DDLogLevelError;
#endif

#ifdef POD_CONFIGURATION_BETA
    #define INTERNALSDK
#end

#ifdef INTERNALSDK
    #define USE_INTERNAL_FEATURES
#endif


@class CammentSDK;

#define CMLocalized(str) NSLocalizedStringFromTableInBundle(str, @"CammentSDK", [NSBundle cammentSDKBundle], @"")

#endif
#endif /* Prefix_h */
