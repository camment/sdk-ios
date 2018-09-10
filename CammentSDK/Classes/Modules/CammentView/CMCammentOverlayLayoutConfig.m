//
// Created by Alexander Fedosov on 31.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMCammentOverlayLayoutConfig.h"


@implementation CMCammentOverlayLayoutConfig {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cammentButtonLayoutPosition = CMCammentOverlayLayoutPositionTopRight;
        self.cammentButtonLayoutVerticalInset = 20.0f;
        self.leftSidebarWidth = 240.0f;
    }

    return self;
}


+ (CMCammentOverlayLayoutConfig *)defaultLayoutConfig {
    return [CMCammentOverlayLayoutConfig new];
}

- (void)setLeftSidebarWidth:(CGFloat)leftSidebarWidth {
    _leftSidebarWidth = (leftSidebarWidth >= 200.0f) ? leftSidebarWidth : 200.0f;
}
@end
