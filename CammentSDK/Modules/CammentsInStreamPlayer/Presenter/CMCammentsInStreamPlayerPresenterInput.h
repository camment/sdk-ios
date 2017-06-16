//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerPresenterInput.h
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//


#import <Foundation/Foundation.h>

@class SCImageView;

@protocol CMCammentsInStreamPlayerPresenterInput <NSObject>

- (void)setupView;
- (void)connectPreviewViewToRecorder:(SCImageView *)view;
- (UIInterfaceOrientationMask)contentPossibleOrientationMask;
- (void)inviteFriendsAction;
@end