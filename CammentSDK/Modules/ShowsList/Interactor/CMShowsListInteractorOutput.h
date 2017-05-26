//
//  CMShowsListCMShowsListInteractorOutput.h
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMShowList;

@protocol CMShowsListInteractorOutput <NSObject>

- (void)showListDidFetched:(CMShowList *)list;
- (void)showListFetchingFailed:(NSError *)error;

@end