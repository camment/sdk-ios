//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerInteractorOutput.h
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Camment;
@class Ads;
@class UserJoinedMessage;
@class CammentDeletedMessage;

@protocol CMCammentsLoaderInteractorOutput <NSObject>

- (void)didFetchCamments:(NSArray<Camment *> *)camments;
- (void)didReceiveNewCamment:(Camment *)camment;
- (void)didReceiveNewAds:(Ads *)ads;

- (void)didReceiveUserJoinedMessage:(UserJoinedMessage *)message;

- (void)didReceiveCammentDeletedMessage:(CammentDeletedMessage *)message;
@end