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

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelAll;
#else
static const DDLogLevel ddLogLevel = DDLogLevelError;
#endif

#ifdef INTERNALSDK

#define USE_INTERNAL_FEATURES 1

#else

#endif


@class CammentSDK;

#define CMLocalized(str) NSLocalizedStringFromTableInBundle(str, @"CammentSDK", [NSBundle bundleForClass:[CammentSDK class]], @"")

#endif

#endif /* Prefix_h */
