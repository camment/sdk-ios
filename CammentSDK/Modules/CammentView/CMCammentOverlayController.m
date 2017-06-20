//
// Created by Alexander Fedosov on 20.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMCammentOverlayController.h"
#import "CMCammentsLoaderInteractorOutput.h"
#import "CMCammentRecorderInteractorOutput.h"
#import "CMCammentViewWireframe.h"
#import "Show.h"

@interface CMCammentOverlayController ()
@property(nonatomic, strong) CMCammentViewController *cammentViewController;
@end

@implementation CMCammentOverlayController

- (instancetype)initWithShow:(Show *)show {
    self = [super init];
    if (self) {
        self.cammentViewController = [[[CMCammentViewWireframe alloc] initWithShow:show] controller];
    }
    return self;
}

- (void)addToParentViewController:(UIViewController *)viewController {
    [viewController addChildViewController:self.cammentViewController];
}

- (void)removeFromParentViewController {
    [self.cammentViewController removeFromParentViewController];
}

- (UIView *)cammentView {
    return [self.cammentViewController view];
}

- (void)setContentView:(UIView *_Nonnull)contentView {
    [self.cammentViewController.node setContentView:contentView];
}


- (UIInterfaceOrientationMask)contentPossibleOrientationMask {
    return [self.cammentViewController.presenter contentPossibleOrientationMask];
}
@end
