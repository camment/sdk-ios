//
//  CMErrorViewInterface.h
//  sendy
//
//  Created by Alexander Fedosov on 04.11.15.
//  Copyright © 2015 Alexander Fedosov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMErrorViewInterface <NSObject>

- (void)setErrorTitle:(NSString *)title;
- (void)setErrorMessage:(NSString *)message;

@end
