//
// Created by Alexander Fedosov on 03/09/2018.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CMProgressiveImageView : UIImageView

@property (nonatomic, strong) NSURL *URL;
@property(nonatomic, copy) dispatch_block_t loadingHandler;

@end
