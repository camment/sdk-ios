//
// Created by Alexander Fedosov on 22.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <ImageIO/ImageIO.h>;
#import "CMAutoFrameFilter.h"
#import "ofxCvColorImage.h"
#import "ofxFaceTrackerThreaded.h"
#import "ofxCv.h"


@implementation CMAutoFrameFilter {
//    ofxFaceTrackerThreaded camTracker;
//    ofPixels pixels;
}

//- (instancetype)initWithCIFilter:(CIFilter *__nullable)filter {
//    self = [super initWithCIFilter:filter];
//    if (self) {
//        camTracker.setup();
//        if ( !camTracker.isThreadRunning() ) {
//            camTracker.startThread();
//        }
//    }
//
//    return self;
//}


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

//    [self loadPixels:image.CGImage];
//    camTracker.update(ofxCv::toCv(pixels));
//    bool found = camTracker.getFound();
//    if (found) {
//        ofMesh camMesh = camTracker.getImageMesh();
//
//    }
//    NSLog(@"Found %d", found);

    return image;
}

- (BOOL)isEmpty {
    return NO;
}

//- (void)loadPixels:(CGImageRef)image{
//
//    CGContextRef photoContext;
//    pixels.allocate(CGImageGetWidth(image), CGImageGetHeight(image), 4);
//
//    size_t width = pixels.getWidth();
//    size_t height = pixels.getHeight();
//    size_t bpp = pixels.getNumChannels();
//
//    photoContext = CGBitmapContextCreate(pixels.getData(), width, height, 8, width * bpp, CGImageGetColorSpace(image), kCGImageAlphaPremultipliedLast);
//
//    CGContextDrawImage(photoContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), image);
//    CGContextRelease(photoContext);
//}

@end
