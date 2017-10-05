//
//  CMCammentsInStreamPlayerViewController.m
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <CammentSDK/CammentSDK.h>
#import "CMCammentsInStreamPlayerViewController.h"
#import "CMAPIShow.h"
#import "CMShow.h"
#import "CMVideoContentPlayerNode.h"
#import "CMWebContentPlayerNode.h"
#import "UIViewController+LoadingHUD.h"

@interface CMCammentsInStreamPlayerViewController () <CMCammentOverlayControllerDelegate, CMCammentSDKUIDelegate>

@property (nonatomic, strong) CMCammentOverlayController *cammentOverlayController;
@property(nonatomic, strong) ASDisplayNode* contentViewerNode;

@property(nonatomic, copy) NSString *showUuid;
@end

@implementation CMCammentsInStreamPlayerViewController

- (instancetype)initWithShow:(CMShow *)show {
    self = [super init];
    if (self) {
        self.showUuid = show.uuid;
        ASDisplayNode *loadingNode = [ASDisplayNode new];
        loadingNode.backgroundColor = [UIColor blackColor];
        self.contentViewerNode = loadingNode;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CMShowMetadata *metadata = [CMShowMetadata new];
    metadata.uuid = self.showUuid;

    _cammentOverlayController = [[CMCammentOverlayController alloc] initWithShowMetadata:metadata];
    _cammentOverlayController.overlayDelegate = self;
    [_cammentOverlayController addToParentViewController:self];
    [self.view addSubview:[_cammentOverlayController cammentView]];
    [_cammentOverlayController setContentView:self.contentViewerNode.view];
    
    UISwipeGestureRecognizer *dismissViewControllerGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController)];
    dismissViewControllerGesture.direction = UISwipeGestureRecognizerDirectionRight;
    dismissViewControllerGesture.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:dismissViewControllerGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [CammentSDK instance].sdkUIDelegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.presenter setupView];
}
    
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [[_cammentOverlayController cammentView] setFrame:self.view.bounds];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startShow:(CMShow *)show {

    [show.showType matchVideo:^(CMAPIShow *matchedShow) {
        self.contentViewerNode = [CMVideoContentPlayerNode new];
    } html:^(NSString *webURL) {
        self.contentViewerNode = [CMWebContentPlayerNode new];
    }];

    [_cammentOverlayController setContentView:self.contentViewerNode.view];

    [(id<CMContentViewerNode>)self.contentViewerNode openContentAtUrl:[[NSURL alloc] initWithString:show.url]];
}

- (void)cammentOverlayDidStartRecording {
    if ([self.contentViewerNode isKindOfClass:[CMVideoContentPlayerNode class]]) {
        [(CMVideoContentPlayerNode *)self.contentViewerNode setMuted:YES];
    }
}

- (void)cammentOverlayDidFinishRecording {
    if ([self.contentViewerNode isKindOfClass:[CMVideoContentPlayerNode class]]) {
        [(CMVideoContentPlayerNode *)self.contentViewerNode setMuted:NO];
    }
}

- (void)cammentOverlayDidStartPlaying {
    if ([self.contentViewerNode isKindOfClass:[CMVideoContentPlayerNode class]]) {
        [(CMVideoContentPlayerNode *)self.contentViewerNode setLowVolume:YES];
    }
}

- (void)cammentOverlayDidFinishPlaying {
    if ([self.contentViewerNode isKindOfClass:[CMVideoContentPlayerNode class]]) {
        [(CMVideoContentPlayerNode *)self.contentViewerNode setLowVolume:NO];
    }
}

- (void)cammentSDKWantsPresentViewController:(UIViewController *_Nonnull)viewController {
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
            [self presentViewController:viewController animated:YES completion:^{}];
        }];
    } else {
        [self presentViewController:viewController animated:YES completion:^{}];
    }
}

@end
