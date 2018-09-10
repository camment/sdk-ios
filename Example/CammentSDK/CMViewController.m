//
//  CMViewController.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 08/07/2018.
//  Copyright (c) 2018 Alexander Fedosov. All rights reserved.
//

#import <CammentSDK/CammentSDK.h>
#import "CMViewController.h"

@interface CMViewController () <CMCammentSDKUIDelegate, CMCammentOverlayControllerDelegate>

@property (nonatomic, strong) CMCammentOverlayController *cammentOverlayController;
@property (nonatomic, strong) UIView *playerView;

@end

@implementation CMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CMShowMetadata *metadata = [CMShowMetadata new];
    metadata.uuid = @"Any string unique identifier of your show";
    
    CMCammentOverlayLayoutConfig *overlayLayoutConfig = [CMCammentOverlayLayoutConfig new];
    // Let's display camment button at bottom right corner
    overlayLayoutConfig.cammentButtonLayoutPosition = CMCammentOverlayLayoutPositionBottomRight;
    self.cammentOverlayController = [[CMCammentOverlayController alloc] initWithShowMetadata:metadata overlayLayoutConfig:overlayLayoutConfig];
    [self.cammentOverlayController addToParentViewController:self];
    [self.view addSubview:[_cammentOverlayController cammentView]];
    
    self.playerView = [UIView new];
    self.playerView.backgroundColor = [UIColor redColor];
    [self.cammentOverlayController setContentView:self.playerView];
    self.cammentOverlayController.overlayDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [CammentSDK instance].sdkUIDelegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [[self.cammentOverlayController cammentView] setFrame:self.view.bounds];
}

#pragma mark Camment Overlay delegates

- (void)cammentOverlayDidStartRecording {
    // Mute your player here
}

- (void)cammentOverlayDidFinishRecording {
    // Restore normal volume
}

- (void)cammentOverlayDidStartPlaying {
    // Decrease volume level
}

- (void)cammentOverlayDidFinishPlaying {
    // Restore normal volume
}

#pragma mark Camment SDK delegates

- (void)cammentSDKWantsPresentViewController:(UIViewController *_Nonnull)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
