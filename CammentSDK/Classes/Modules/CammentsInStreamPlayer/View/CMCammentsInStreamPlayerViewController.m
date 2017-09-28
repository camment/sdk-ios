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
#import "GVUserDefaults.h"
#import "GVUserDefaults+CammentSDKConfig.h"
#import "CMWaitContentNode.h"

@interface CMCammentsInStreamPlayerViewController () <CMCammentOverlayControllerDelegate>

@property (nonatomic, strong) CMCammentOverlayController *cammentOverlayController;
@property(nonatomic, strong) ASDisplayNode* contentViewerNode;
@property(nonatomic) RACDisposable *countDownSignalDisposable;

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
    if (!self.countDownSignalDisposable) {
        [CMStore instance].scheduledDate = [NSDate dateWithTimeIntervalSinceNow:10];
    }


    CMShowMetadata *metadata = [CMShowMetadata new];
    metadata.uuid = show.uuid;

    if (!_cammentOverlayController) {
        _cammentOverlayController = [[CMCammentOverlayController alloc] initWithShowMetadata:metadata];
        _cammentOverlayController.overlayDelegate = self;
        [_cammentOverlayController addToParentViewController:self];
        [self.view addSubview:[_cammentOverlayController cammentView]];
    }

    NSString *passcode = [[GVUserDefaults standardUserDefaults] broadcasterPasscode];
    if ([passcode isEqualToString:[CMStore instance].scheduledShowsPasscode]
            && [[NSDate date] isEarlierThan:[CMStore instance].scheduledDate]) {
        self.contentViewerNode = [[CMWaitContentNode alloc] initWithStartDate:[CMStore instance].scheduledDate];

        RACSignal * countDownSignal = [[[RACSignal interval:1
                  onScheduler:[RACScheduler mainThreadScheduler]]
                startWith:[NSDate date]]
                takeUntil:self.rac_willDeallocSignal];
        if (self.countDownSignalDisposable) {
            [self.countDownSignalDisposable dispose];
        }

        @weakify(self);
        self.countDownSignalDisposable = [[countDownSignal takeWhileBlock:^BOOL(id x) {
            return [[NSDate date] isEarlierThan:[CMStore instance].scheduledDate];
        }] subscribeCompleted:^{
            @strongify(self);
            [self startShow:show];
        }];

    } else {
        [show.showType matchVideo:^(CMAPIShow *matchedShow) {
            self.contentViewerNode = [CMVideoContentPlayerNode new];
            if ([show.uuid isEqualToString:[CMStore instance].scheduledShowsPasscode]) {
                [(CMVideoContentPlayerNode *)self.contentViewerNode setStartsAt:[CMStore instance].scheduledDate];
            }
        } html:^(NSString *webURL) {
            self.contentViewerNode = [CMWebContentPlayerNode new];
        }];
    }


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
