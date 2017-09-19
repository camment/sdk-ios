//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerInteractorOutput.h
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMCamment;
@class CMBotCamment;
@class CMUserJoinedMessage;
@class CMCammentDeletedMessage;

@protocol CMCammentsLoaderInteractorOutput <NSObject>

- (void)didFetchCamments:(NSArray<CMCamment *> *)camments;
- (void)didReceiveNewCamment:(CMCamment *)camment;
- (void)didReceiveNewBotCamment:(CMBotCamment *)ads;

- (void)didReceiveUserJoinedMessage:(CMUserJoinedMessage *)message;

- (void)didReceiveCammentDeletedMessage:(CMCammentDeletedMessage *)message;
@end