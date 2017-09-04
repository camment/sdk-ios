//
// Created by Alexander Fedosov on 22.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMShow;

@protocol CMShowsListCollectionPresenterOutput <NSObject>

- (void)didSelectShow:(CMShow *)show;

@end