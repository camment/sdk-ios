//
//  CMErrorWireframe.h
//  sendy
//
//  Created by Alexander Fedosov on 04.11.15.
//  Copyright © 2015 Alexander Fedosov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CMErrorWireframe : NSObject

@property (nonatomic, weak) UIViewController *presentingViewController;

- (void)presentErrorViewWithError:(NSError *)error inViewController:(UIViewController *)viewController;

@end
