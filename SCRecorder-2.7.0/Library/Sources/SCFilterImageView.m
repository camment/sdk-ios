//
//  SCFilterImageView.m
//  SCRecorder
//
//  Created by Simon Corsin on 10/8/15.
//  Copyright © 2015 rFlex. All rights reserved.
//

@import ImageIO;
#import "SCFilterImageView.h"

@implementation SCFilterImageView {
    CIContext *_ciContext;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _useAutoAdjustmentFilters = NO;
    }

    return self;
}


- (CIImage *)renderedCIImageInRect:(CGRect)rect {
    CIImage *image = [super renderedCIImageInRect:rect];

    if (image != nil) {
        if (_filter != nil) {
            if (_useAutoAdjustmentFilters) {
                NSDictionary *options = @{ CIDetectorImageOrientation:
                        ([[image properties] valueForKey:kCGImagePropertyOrientation] ?: @1) };
                NSArray *adjustments = [image autoAdjustmentFiltersWithOptions:options];
                for (CIFilter *filter in adjustments) {
                    [filter setValue:image forKey:kCIInputImageKey];
                    image = filter.outputImage;
                }
            }

            image = [_filter imageByProcessingImage:image atTime:self.CIImageTime];
        }
    }

    return image;
}

- (void)setFilter:(SCFilter *)filter {
    _filter = filter;

    [self setNeedsDisplay];
}

@end
