//
//  CMCammentsInStreamPlayerViewController.m
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "CMCammentsInStreamPlayerViewController.h"
#import "CMShow.h"
#import "Show.h"
#import "CMCammentViewPresenterInput.h"
#import "CMCammentOverlayController.h"
#import "CMVideoContentPlayerNode.h"
#import "CMWebContentPlayerNode.h"

@interface CMCammentsInStreamPlayerViewController ()

@property (nonatomic, strong) CMCammentOverlayController *cammentOverlayController;
@property (nonatomic, strong) UIView *cammentsOverlayView;
@property(nonatomic, strong) ASDisplayNode* contentViewerNode;

@end

@implementation CMCammentsInStreamPlayerViewController

- (instancetype)init {
    self = [super init];
    if (self) {
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UISwipeGestureRecognizer *dismissViewControllerGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController)];
    dismissViewControllerGesture.direction = UISwipeGestureRecognizerDirectionRight;
    dismissViewControllerGesture.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:dismissViewControllerGesture];

    [self.presenter setupView];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.cammentsOverlayView setFrame:self.view.bounds];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startShow:(Show *)show {
    if (_cammentOverlayController) {
        [_cammentOverlayController removeFromParentViewController];
        [self.cammentsOverlayView removeFromSuperview];
    }

    _cammentOverlayController = [[CMCammentOverlayController alloc] initWithShow:show];
    [_cammentOverlayController addToParentViewController:self];
    self.cammentsOverlayView = [_cammentOverlayController cammentView];
    [self.view addSubview:self.cammentsOverlayView];

    [show.showType matchVideo:^(CMShow *matchedShow) {
        self.contentViewerNode = [CMVideoContentPlayerNode new];
    } html:^(NSString *webURL) {
        self.contentViewerNode = [CMWebContentPlayerNode new];
    }];

    [_cammentOverlayController setContentView:self.contentViewerNode.view];
    [(id<CMContentViewerNode>)self.contentViewerNode openContentAtUrl:[[NSURL alloc] initWithString:show.url]];
}

@end
