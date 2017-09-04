//
//  CMShowsListCMShowsListInteractorOutput.h
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMAPIShowList;

@protocol CMShowsListInteractorOutput <NSObject>

- (void)showListDidFetched:(CMAPIShowList *)list;
- (void)showListFetchingFailed:(NSError *)error;

@end