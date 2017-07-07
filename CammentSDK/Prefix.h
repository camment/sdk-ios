//
//  Prefix.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 30.05.17.
//  Copyright © 2017 Camment. All rights reserved.
//

#ifndef Prefix_h
#define Prefix_h

#define LOG_LEVEL_DEF ddLogLevel
#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelAll;
#else
static const DDLogLevel ddLogLevel = DDLogLevelError;
#endif

@class CammentSDK;

#define CMLocalized(str) NSLocalizedStringFromTableInBundle(str, @"CammentSDK", [NSBundle bundleForClass:[CammentSDK class]], @"")

#endif /* Prefix_h */
