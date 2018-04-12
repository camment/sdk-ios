//
//  ViewController.m
//  rtve karaoke demo
//
//  Created by Alexander Fedosov on 12.04.2018.
//  Copyright © 2018 Alexander Fedosov. All rights reserved.
//

#import "ViewController.h"
#import <CammentSDK/CammentSDK.h>

@interface ViewController ()<CMCammentSDKUIDelegate, CMCammentSDKDelegate>
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [CammentSDK instance].sdkUIDelegate = self;
    [CammentSDK instance].sdkDelegate = self;
}

- (void)openKaraokeView {
    CMKaraokeShowListModule *showsList = [CMKaraokeShowListModule new];
    [showsList pushInNavigationController:self.navigationController];
}

- (IBAction)openKaraokeView:(id)sender {
    [self openKaraokeView];
}

- (void)cammentSDKWantsPresentViewController:(UIViewController *_Nonnull)viewController {
    if (self.presentedViewController) { return; }
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)didOpenInvitationToShow:(CMShowMetadata *)metadata {
    [self openKaraokeView];
}

- (void)didJoinToShow:(CMShowMetadata *)metadata {
    // CammentSDK will open view with a show automaitcally 
}

@end
