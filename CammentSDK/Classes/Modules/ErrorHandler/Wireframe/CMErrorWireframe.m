//
//  CMErrorWireframe.m
//  sendy
//
//  Created by Alexander Fedosov on 04.11.15.
//  Copyright © 2015 Alexander Fedosov. All rights reserved.
//

#import "CMErrorWireframe.h"
#import "CMErrorViewController.h"
#import "CMErrorPresenter.h"

@implementation CMErrorWireframe

- (void)presentErrorViewWithError:(NSError *)error inViewController:(UIViewController *)viewController{
    self.presentingViewController = viewController;
    
    NSString *title = CMLocalized(@"Error");
    NSString *message = error.localizedDescription;

    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:CMLocalized(@"Error") otherButtonTitles:nil] show];
#else
    CMErrorViewController *controller = [CMErrorViewController
            alertControllerWithTitle:title
                             message:message
                      preferredStyle:UIAlertControllerStyleAlert];
    
    CMErrorPresenter *presenter = [CMErrorPresenter new];
    presenter.error = error;
    controller.presenter = presenter;
    presenter.viewInterface = controller;
    presenter.wireframe = self;
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:CMLocalized(@"Close") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [controller addAction:cancelAction];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [controller setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [controller
                popoverPresentationController];

        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionLeft;
        popPresenter.sourceView = viewController.view;
        popPresenter.sourceRect = viewController.view.bounds;
    }

    [viewController presentViewController:controller animated:YES completion:nil];
#endif
}

@end
