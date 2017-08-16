//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerWireframe.m
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <AsyncDisplayKit/ASCollectionNode.h>
#import "CMCammentsInStreamPlayerWireframe.h"


@implementation CMCammentsInStreamPlayerWireframe

- (instancetype)initWithShow:(CMShow *)show {
    self = [super init];
    if (self) {
        self.show = show;
    }

    return self;
}


- (void)presentInWindow:(UIWindow *)window; {
    CMCammentsInStreamPlayerViewController *view = [CMCammentsInStreamPlayerViewController new];
    CMCammentsInStreamPlayerPresenter *presenter = [[CMCammentsInStreamPlayerPresenter alloc] initWithShow:_show];

    view.presenter = presenter;
    presenter.output = view;
    presenter.wireframe = self;

    self.view = view;
    self.presenter = presenter;

    [window setRootViewController:view];
}

- (void)presentInViewController:(UIViewController *)viewController {
    self.parentViewController = viewController;
    CMCammentsInStreamPlayerViewController *view = [CMCammentsInStreamPlayerViewController new];
    CMCammentsInStreamPlayerPresenter *presenter = [[CMCammentsInStreamPlayerPresenter alloc] initWithShow:_show];

    view.presenter = presenter;
    presenter.output = view;
    presenter.wireframe = self;

    self.view = view;
    self.presenter = presenter;

    [viewController presentViewController:view animated:YES completion:nil];
}

- (void)pushInNavigationController:(UINavigationController *)navigationController {
    self.parentNavigationController = navigationController;
    CMCammentsInStreamPlayerViewController *view = [CMCammentsInStreamPlayerViewController new];
    CMCammentsInStreamPlayerPresenter *presenter = [[CMCammentsInStreamPlayerPresenter alloc] initWithShow:_show];

    view.presenter = presenter;
    presenter.output = view;
    presenter.wireframe = self;

    self.view = view;
    self.presenter = presenter;

    [navigationController pushViewController:view animated:YES];
}

@end
