//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerInteractorInput.h
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMCammentsLoaderInteractorInput <NSObject>

- (void)loadNextPageOfCamments:(NSString *)groupUUID;

- (void)resetPaginationKey;

- (void)fetchCammentsFrom:(NSString *)from to:(NSString *)to groupUuid:(NSString *)uuid;
@end