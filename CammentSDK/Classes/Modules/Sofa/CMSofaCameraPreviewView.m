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
    }

    return self;
}

@end