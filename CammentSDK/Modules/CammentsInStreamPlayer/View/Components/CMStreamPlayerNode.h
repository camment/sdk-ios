//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>


@interface CMStreamPlayerNode : ASDisplayNode

- (void)playVideoAtURL:(NSURL *)url;

@end