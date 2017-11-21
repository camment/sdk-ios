//
//  CMOpenURLHelper.h
//  Pods
//
//  Created by Alexander Fedosov on 21.11.2017.
//

#import <Foundation/Foundation.h>

@interface CMOpenURLHelper : NSObject

- (void)openURL:(NSURL *)url;
- (void)openURLString:(NSString *)urlString;

@end
