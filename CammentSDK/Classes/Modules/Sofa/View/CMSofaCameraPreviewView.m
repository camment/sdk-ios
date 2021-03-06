//
// Created by Alexander Fedosov on 20/08/2018.
//

#import "CMSofaCameraPreviewView.h"


@implementation CMSofaCameraPreviewView {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 2.0f;
        self.layer.cornerRadius = 4.0f;
        self.clipsToBounds = YES;

        self.imageView = [SCImageView new];
        self.imageView.contextType = SCContextTypeEAGL;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageView setClearsContextBeforeDrawing:YES];
        [self.imageView loadContextIfNeeded];
        [self addSubview:self.imageView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

- (void)setPermissionsGrantedState {
    [self.imageView setImageByUIImage:nil];
}

- (void)setPermissionsDeniedState {
    [self.imageView setImageByUIImage:[UIImage imageNamed:@"no_permissions_icon"
                                                 inBundle:[NSBundle cammentSDKBundle]
                            compatibleWithTraitCollection:nil]];
    [self.imageView setNeedsDisplay];
}

- (void)setPermissionsNotDeterminedState {
    [self.imageView setImageByUIImage:[UIImage imageNamed:@"sofa_camera_icon"
                                                 inBundle:[NSBundle cammentSDKBundle]
                            compatibleWithTraitCollection:nil]];
    [self.imageView setNeedsDisplay];
}


@end