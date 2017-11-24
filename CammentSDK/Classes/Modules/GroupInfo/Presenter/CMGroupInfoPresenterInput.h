//
//  CMGroupInfoCMGroupInfoPresenterInput.h
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CMGroupInfoNode.h"

@protocol CMGroupInfoPresenterInput <NSObject, CMGroupInfoNodeDelegate>

- (void)setupView;

@end