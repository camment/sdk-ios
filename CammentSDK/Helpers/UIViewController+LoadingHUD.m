//
// Created by Alexander Fedosov on 30.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "UIViewController+LoadingHUD.h"
#import <MBProgressHUD.h>


@implementation UIViewController (LoadingHUD)

- (void)showLoadingHUD {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setAnimationType:MBProgressHUDAnimationFade];
}

- (void)hideLoadingHUD {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


@end