//
//  CMCammentsInStreamPlayerViewController.m
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "CMCammentsInStreamPlayerViewController.h"
#import "CMAPIShow.h"
#import "CMShow.h"
#import "CMCammentOverlayController.h"
#import "CMVideoContentPlayerNode.h"
#import "CMWebContentPlayerNode.h"
#import "CMShowMetadata.h"
#import "CMStore.h"
#import "DateTools.h"

@interface CMCammentsInStreamPlayerViewController () <CMCammentOverlayControllerDelegate>

@property (nonatomic, strong) CMCammentOverlayController *cammentOverlayController;
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

    self.view.backgroundColor = [UIColor blackColor];
    UISwipeGestureRecognizer *dismissViewControllerGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController)];
    dismissViewControllerGesture.direction = UISwipeGestureRecognizerDirectionRight;
    dismissViewControllerGesture.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:dismissViewControllerGesture];

    [self.presenter setupView];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect cammentViewFrame = self.view.bounds;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    cammentViewFrame = CGRectMake(.0f, statusBarHeight, cammentViewFrame.size.width, cammentViewFrame.size.height - statusBarHeight);
    [[_cammentOverlayController cammentView] setFrame:cammentViewFrame];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startShow:(CMShow *)show {
    if (_cammentOverlayController) {
        [_cammentOverlayController removeFromParentViewController];
        [[_cammentOverlayController cammentView] removeFromSuperview];
    }

    if ([show.uuid isEqualToString:[CMStore instance].scheduledShowUuid]
            && [[NSDate date] isEarlierThan:[CMStore instance].scheduledDate]) {

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Not ready yet.."
                                                                                 message:[NSString stringWithFormat:@"Stream starts at %@", [[CMStore instance].scheduledDate formattedDateWithFormat:@"HH:mm"]]
                                                                          preferredStyle:UIAlertControllerStyleAlert];

        [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Ok") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
        
        return;
    }

    CMShowMetadata *metadata = [CMShowMetadata new];
    metadata.uuid = show.uuid;

    _cammentOverlayController = [[CMCammentOverlayController alloc] initWithShowMetadata:metadata];
    _cammentOverlayController.overlayDelegate = self;
    [_cammentOverlayController addToParentViewController:self];
    [self.view addSubview:[_cammentOverlayController cammentView]];

    [show.showType matchVideo:^(CMAPIShow *matchedShow) {
        self.contentViewerNode = [CMVideoContentPlayerNode new];
        if ([show.uuid isEqualToString:[CMStore instance].scheduledShowUuid]) {
            [(CMVideoContentPlayerNode *)self.contentViewerNode setStartsAt:[CMStore instance].scheduledDate];
        }
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
