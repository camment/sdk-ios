//
//  CMOpenURLHelper.m
//  Pods
//
//  Created by Alexander Fedosov on 21.11.2017.
//

#import "CMOpenURLHelper.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation CMOpenURLHelper

- (void)openURL:(NSURL *)url {
    UIApplication *application = [UIApplication sharedApplication];

    if (@available(iOS 10.0, *)) {
        [application openURL:url options:@{} completionHandler:^(BOOL success) {}];
    } else {
        [application openURL:url];
    }
}

- (void)openURLString:(NSString *)urlString {
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    if (url) {
        [self openURL:url];
    }
}

@end
