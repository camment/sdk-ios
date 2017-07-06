//
// Created by Alexander Fedosov on 22.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

@import ImageIO;
#import "CMAutoFrameFilter.h"


@implementation CMAutoFrameFilter

- (CIImage *)imageByProcessingImage:(CIImage *)image atTime:(CFTimeInterval)time {

    id<SCFilterDelegate> delegate = self.delegate;

    if ([delegate respondsToSelector:@selector(filter:willProcessImage:atTime:)]) {
        [delegate filter:self willProcessImage:image atTime:time];
    }

    NSString *orientation = (__bridge NSString *)kCGImagePropertyOrientation;
    NSDictionary *options = @{ CIDetectorImageOrientation:
            ([[image properties] valueForKey:orientation] ?: @1) };
    NSArray *adjustments = [image autoAdjustmentFiltersWithOptions:options];
    for (CIFilter *filter in adjustments) {
        [filter setValue:image forKey:kCIInputImageKey];
        image = filter.outputImage;
    }

    return image;
}

- (BOOL)isEmpty {
    return NO;
}

@end
