//
// Created by Alexander Fedosov on 25.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMVideoShowCellNode.h"
#import "CMShow.h"
#import "DateTools.h"


@interface CMVideoShowCellNode ()
@property(nonatomic, strong) ASVideoNode *videoThumbnailNode;
@property(nonatomic, strong) ASTextNode *startsDateText;
@property(nonatomic, strong) ASDisplayNode *textBackNode;
@end

@implementation CMVideoShowCellNode

- (instancetype)initWithShow:(CMShow *)show {
    self = [super initWithShow:show];
    if (self) {
        self.videoThumbnailNode = [ASVideoNode new];
        self.videoThumbnailNode.enabled = NO;
        self.videoThumbnailNode.gravity = AVLayerVideoGravityResizeAspectFill;
        self.videoThumbnailNode.cornerRadius = 15.0f;
        self.videoThumbnailNode.clipsToBounds = YES;

        self.textBackNode = [ASDisplayNode new];
        self.textBackNode.backgroundColor = [UIColor blackColor];
        
        self.startsDateText = [ASTextNode new];
        self.startsDateText.shadowColor = [UIColor blackColor].CGColor;
        self.startsDateText.shadowRadius = 2.0f;
        self.startsDateText.shadowOpacity = 1;
        self.startsDateText.shadowOffset = CGSizeMake(.0f, .0f);
        self.startsDateText.clipsToBounds = YES;
        self.startsDateText.cornerRadius = 9.0f;
        self.startsDateText.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        NSDate *date = show.startsAt ? [NSDate dateWithTimeIntervalSince1970:show.startsAt.integerValue] : nil;
        if (date) {
            NSString *dateText = [NSString stringWithFormat:@" Watch on %@ ", [date formattedDateWithFormat:@"EEEE, d MMM, HH:mm"]];
            self.startsDateText.attributedText = [[NSAttributedString alloc] initWithString:dateText
                                                                                 attributes:@{
                                                                                         NSFontAttributeName: [UIFont boldSystemFontOfSize:12],
                                                                                         NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                 }];
        }
        
        
    }

    return self;
}

- (void)didEnterPreloadState {
    [super didEnterPreloadState];

    _videoThumbnailNode.contentMode = UIViewContentModeScaleAspectFill;
    _videoThumbnailNode.backgroundColor = [UIColor grayColor];
    
    BOOL hasThumbnails = self.show.thumbnail != nil;
    NSString *previewURL = hasThumbnails ? self.show.thumbnail : self.show.url;
    if (!previewURL) { return; }
    
    NSURL *url = [[NSURL alloc] initWithString:previewURL];
    if (!url) { return;}

    if (hasThumbnails) {
        [_videoThumbnailNode setURL:url resetToDefault:YES];
    } else {
        [_videoThumbnailNode setAssetURL:url];
    }
}

- (ASLayoutSpec *)contentNode {
    
    if (!self.show.startsAt) {
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, .0f) child:_videoThumbnailNode];
    }
    
    return [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_videoThumbnailNode
                                                   overlay:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(INFINITY, 10.0f, 10.0f, INFINITY) child:_startsDateText]];
}


- (UIImage *)thumbnailImage {
    return [_videoThumbnailNode image];
}

@end
