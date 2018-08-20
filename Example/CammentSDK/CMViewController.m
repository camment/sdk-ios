//
//  CMViewController.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 08/07/2018.
//  Copyright (c) 2018 Alexander Fedosov. All rights reserved.
//

#import <CammentSDK/CMSofaView.h>
#import "CMViewController.h"

@interface CMViewController ()

@end

@implementation CMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sofaView = [CMSofaView new];
    [self.view addSubview:self.sofaView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    if (@available(iOS 11, *)) {
        self.sofaView.topInset = self.view.safeAreaInsets.top;
    } else {
        self.sofaView.topInset = self.topLayoutGuide.length;
    }

    self.sofaView.frame = self.view.bounds;
}

@end
