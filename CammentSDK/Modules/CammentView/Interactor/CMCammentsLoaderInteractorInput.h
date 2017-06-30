//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerInteractorInput.h
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMCammentsLoaderInteractorInput <NSObject>

- (void)fetchCachedCamments:(NSString *)groupUUID;

@end