//
//  NSBundle+CammentSDK.m
//  Pods
//
//  Created by Alexander Fedosov on 04.09.17.
//
//

#import "NSBundle+CammentSDK.h"
#import "CammentSDK.h"

@implementation NSBundle (CammentSDK)

+ (NSBundle *)cammentSDKBundle {
    NSBundle *bundle = [NSBundle bundleForClass:[CammentSDK class]];
    return bundle;
}

@end
