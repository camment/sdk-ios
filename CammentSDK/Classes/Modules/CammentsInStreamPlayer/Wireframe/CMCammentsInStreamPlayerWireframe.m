//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerWireframe.m
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <AsyncDisplayKit/ASCollectionNode.h>
#import "CMCammentsInStreamPlayerWireframe.h"
#import "TransitionDelegate.h"


@interface CMCammentsInStreamPlayerWireframe ()
@property(nonatomic, strong) TransitionDelegate *transitionDelegate;
@end

@implementation CMCammentsInStreamPlayerWireframe

- (instancetype)initWithShow:(CMShow *)show {
    self = [super init];
    if (self) {
        self.show = show;
    }

    return self;
}


- (void)presentInWindow:(UIWindow *)window; {
    CMCammentsInStreamPlayerViewController *view = [[CMCammentsInStreamPlayerViewController alloc] initWithShow:_show];
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
    CMCammentsInStreamPlayerViewController *view = [[CMCammentsInStreamPlayerViewController alloc] initWithShow:_show];
    CMCammentsInStreamPlayerPresenter *presenter = [[CMCammentsInStreamPlayerPresenter alloc] initWithShow:_show];

    view.presenter = presenter;
    presenter.output = view;
    presenter.wireframe = self;

    self.view = view;
    self.presenter = presenter;

    self.transitionDelegate = [TransitionDelegate new];
    view.transitioningDelegate = self.transitionDelegate;
    [viewController presentViewController:view animated:YES completion:nil];
}

- (void)pushInNavigationController:(UINavigationController *)navigationController {
    self.parentNavigationController = navigationController;
    CMCammentsInStreamPlayerViewController *view = [[CMCammentsInStreamPlayerViewController alloc] initWithShow:_show];
    CMCammentsInStreamPlayerPresenter *presenter = [[CMCammentsInStreamPlayerPresenter alloc] initWithShow:_show];

    view.presenter = presenter;
    presenter.output = view;
    presenter.wireframe = self;

    self.view = view;
    self.presenter = presenter;

    [navigationController pushViewController:view animated:YES];
}

@end
