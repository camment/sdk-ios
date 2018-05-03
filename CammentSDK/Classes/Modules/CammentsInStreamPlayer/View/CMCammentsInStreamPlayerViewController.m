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
#import "CMShowMetadata.h"
#import "CMStore.h"
#import "DateTools.h"
#import "GVUserDefaults.h"
#import "GVUserDefaults+CammentSDKConfig.h"
#import "CMWaitContentNode.h"
#import "CMAnalytics.h"

@interface CMCammentsInStreamPlayerViewController () <CMCammentOverlayControllerDelegate, CMCammentSDKUIDelegate>

@property (nonatomic, strong) CMCammentOverlayController *cammentOverlayController;
@property(nonatomic) RACDisposable *countDownSignalDisposable;
@property(nonatomic, assign) BOOL viewIsReady;
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

    self.view.backgroundColor = [UIColor blackColor];

    CMShowMetadata *metadata = [CMShowMetadata new];
    metadata.uuid = self.showUuid;

    CMCammentOverlayLayoutConfig *overlayLayoutConfig = [CMCammentOverlayLayoutConfig new];
    overlayLayoutConfig.cammentButtonLayoutPosition = CMCammentOverlayLayoutPositionBottomRight;
    _cammentOverlayController = [[CMCammentOverlayController alloc] initWithShowMetadata:metadata
                                                                     overlayLayoutConfig:overlayLayoutConfig];
    _cammentOverlayController.overlayDelegate = self;
    [_cammentOverlayController addToParentViewController:self];
    [self.view addSubview:[_cammentOverlayController cammentView]];
    [_cammentOverlayController setContentView:self.contentViewerNode.view];

    UISwipeGestureRecognizer *dismissViewControllerGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController)];
    dismissViewControllerGesture.direction = UISwipeGestureRecognizerDirectionRight;
    dismissViewControllerGesture.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:dismissViewControllerGesture];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveNewTimestamp:)
                                                 name:CMNewTimestampAvailableVideoPlayerNotification
                                               object:[CammentSDK instance]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
};

- (void)didReceiveNewTimestamp:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    NSTimeInterval newTimestamp = [(NSNumber *)dict[CMNewTimestampKey] doubleValue];
    BOOL isPlaying = [(NSNumber *)dict[CMVideoIsPlayingKey] boolValue];

    [(id<CMContentViewerNode>)self.contentViewerNode setCurrentTimeInterval:newTimestamp];
    [(id<CMContentViewerNode>)self.contentViewerNode setIsPlaying:isPlaying];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [CammentSDK instance].sdkUIDelegate = self;
    [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventShowScreen];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_viewIsReady) {
        _viewIsReady = YES;
        [self.presenter setupView];
    }
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect cammentViewFrame = self.view.bounds;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    cammentViewFrame = CGRectMake(.0f, statusBarHeight, cammentViewFrame.size.width, cammentViewFrame.size.height - statusBarHeight);
    [[_cammentOverlayController cammentView] setFrame:cammentViewFrame];
}

- (void)dismissViewController {
    [[CammentSDK instance] leaveCurrentChatGroup];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startShow:(CMShow *)show {
    NSDate *startsAt = show.startsAt ? [NSDate dateWithTimeIntervalSince1970:show.startsAt.integerValue] : nil;
    if (startsAt && [[NSDate date] isEarlierThan:startsAt]) {
        self.contentViewerNode = [[CMWaitContentNode alloc] initWithStartDate:startsAt];
        RACSignal * countDownSignal = [[[RACSignal interval:1
                  onScheduler:[RACScheduler mainThreadScheduler]]
                startWith:[NSDate date]]
                takeUntil:self.rac_willDeallocSignal];
        if (self.countDownSignalDisposable) {
            [self.countDownSignalDisposable dispose];
        }

        @weakify(self);
        self.countDownSignalDisposable = [[[countDownSignal takeWhileBlock:^BOOL(id x) {
            return [[NSDate date] isEarlierThan:startsAt];
        }] takeUntil:self.rac_willDeallocSignal] subscribeCompleted:^{
            @strongify(self);
            [self startShow:show];
        }];

    } else {
        [show.showType matchVideo:^(CMAPIShow *matchedShow) {
            self.contentViewerNode = [CMVideoContentPlayerNode new];
            [(CMVideoContentPlayerNode *)self.contentViewerNode setVideoNodeDelegate:self];
            if (startsAt) {
                [(CMVideoContentPlayerNode *)self.contentViewerNode setStartsAt:startsAt];
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

- (void)cammentSDKWantsPresentViewController:(UIViewController *_Nonnull)viewController {
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
            [self presentViewController:viewController animated:YES completion:^{}];
        }];
    } else {
        [self presentViewController:viewController animated:YES completion:^{}];
    }
}

- (void)playerDidUpdateCurrentTimeInterval:(NSTimeInterval)timeInterval {
    CMShowMetadata *metadata = [CMShowMetadata new];
    metadata.uuid = self.showUuid;

    [[CammentSDK instance] updateVideoStreamStateIsPlaying:YES show:metadata timestamp:timeInterval];
}

- (void)playerDidPlay:(NSTimeInterval)timeInterval {
    CMShowMetadata *metadata = [CMShowMetadata new];
    metadata.uuid = self.showUuid;

    [[CammentSDK instance] updateVideoStreamStateIsPlaying:YES show:metadata timestamp:timeInterval];
}

- (void)playerDidPause:(NSTimeInterval)timeInterval {
    CMShowMetadata *metadata = [CMShowMetadata new];
    metadata.uuid = self.showUuid;

    [[CammentSDK instance] updateVideoStreamStateIsPlaying:NO show:metadata timestamp:timeInterval];
}

@end
