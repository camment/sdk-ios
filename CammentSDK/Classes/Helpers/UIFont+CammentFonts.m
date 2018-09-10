//
// Created by Alexander Fedosov on 04.04.2018.
//

#import "UIFont+CammentFonts.h"


@implementation UIFont (CammentFonts)

+ (UIFont *)nunitoMediumWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"Nunito-Medium" size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

+ (UIFont *)nunitoLightWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"Nunito-Light" size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

@end
