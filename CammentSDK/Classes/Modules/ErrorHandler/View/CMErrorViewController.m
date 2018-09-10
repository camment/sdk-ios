//
//  CMErrorViewController.m
//  sendy
//
//  Created by Alexander Fedosov on 04.11.15.
//  Copyright © 2015 Alexander Fedosov. All rights reserved.
//

#import "CMErrorViewController.h"

@implementation CMErrorViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.presenter loadView];
}

#pragma mark - SNDErrorViewInterface

- (void)setErrorTitle:(NSString *)title{
    [self setTitle:title];
}

- (void)setErrorMessage:(NSString *)message{
    [self setMessage:message];
}

@end
