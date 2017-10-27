//
// Created by Alexander Fedosov on 27.10.2017.
//

#import "CMAdsVideoPlayerNode.h"
#import "UIColorMacros.h"
#import "CMVideoAd.h"
#import "CMStore.h"


@implementation CMAdsVideoPlayerNode {

}

- (instancetype)init {
    self = [super init];
    if (self) {

        self.style.width = ASDimensionMake(340.0f);
        self.style.height = ASDimensionMake(200.0f);

        self.videoPlayerNode = [ASVideoNode new];
        self.videoPlayerNode.gravity = AVLayerVideoGravityResizeAspect;
        self.videoPlayerNode.shouldAutorepeat = NO;
        self.videoPlayerNode.shouldAutoplay = YES;
        self.videoPlayerNode.userInteractionEnabled = NO;

        self.openLinkButton = [ASButtonNode new];
        self.openLinkButton.backgroundColor = UIColorFromRGB(0xD0021B);
        self.openLinkButton.style.width = ASDimensionMake(120.0f);
        self.openLinkButton.style.height = ASDimensionMake(20.0f);
        self.openLinkButton.cornerRadius = 3.0f;
        [self.openLinkButton setAttributedTitle:[[NSAttributedString alloc] initWithString:CMLocalized(@"CLICK TO LEARN MORE")
                                                                                attributes:@{
                                                                                        NSFontAttributeName: [UIFont fontWithName:@"Nunito-Medium" size:10],
                                                                                        NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                }]
                                       forState:UIControlStateNormal];
        [self.openLinkButton addTarget:self
                                action:@selector(tapOpenLinkButton)
                      forControlEvents:ASControlNodeEventTouchUpInside];

        self.closeButtonNode = [ASButtonNode new];
        [self.closeButtonNode setImage:[UIImage imageNamed:@"close_ads_button"
                                                  inBundle:[NSBundle cammentSDKBundle]
                             compatibleWithTraitCollection:nil]
                              forState:UIControlStateNormal];
        [self.closeButtonNode addTarget:self
                                 action:@selector(didTapCloseOnButton)
                       forControlEvents:ASControlNodeEventTouchUpInside];

        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didLoad {
    [super didLoad];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapOpenLinkButton)]];
}

- (void)layout {
    [super layout];
    [self updateShadow];
}

- (void)updateShadow {
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 15.0f;
    self.layer.shadowOpacity = .3f;
    self.layer.shadowOffset = CGSizeMake(.0f, .0f);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds cornerRadius:15.0f].CGPath;
}

- (void)didTapCloseOnButton {
    [CMStore instance].playingCammentId = kCMStoreCammentIdIfNotPlaying;
    [self.videoPlayerNode pause];
    [self.delegate cmAdsVideoPlayerNodeDidClose];
}

- (void)play:(CMVideoAd *)videoAd {
    [CMStore instance].playingCammentId = @"kVideoAds";
    self.videoAd = videoAd;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.videoPlayerNode pause];
        [self.videoPlayerNode.player seekToTime:kCMTimeZero];
        [self.videoPlayerNode setAssetURL:self.videoAd.videoURL];
        [self.videoPlayerNode play];
    });
}

- (void)tapOpenLinkButton {
    [self didTapCloseOnButton];
    NSURL *url = self.videoAd.targetUrl;
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    self.closeButtonNode.style.preferredSize = CGSizeMake(30, 30);
    self.closeButtonNode.style.layoutPosition = CGPointMake(0.0f, 0.0f);

    ASOverlayLayoutSpec *overlayLayoutSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(12.0f, 15.0f, .0f, .0f) child:_videoPlayerNode]
                                                                                     overlay:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(INFINITY, 15.0f, 4.0f, .0f)
                                                                                                                                    child:[ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringX
                                                                                                                                                                                     sizingOptions:ASCenterLayoutSpecSizingOptionMinimumY
                                                                                                                                                                                             child:_openLinkButton]]];
    return [ASOverlayLayoutSpec overlayLayoutSpecWithChild:overlayLayoutSpec
                                                   overlay:[ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[_closeButtonNode]]];
}

@end