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

@protocol CMCammentsInStreamPlayerInteractorOutput <NSObject>

- (void)didFetchCamments:(NSArray<Camment *> *)camments;
- (void)didReceiveNewCamment:(Camment *)camment;
- (void)didReceiveNewAds:(Ads *)ads;

@end