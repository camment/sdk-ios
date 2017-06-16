//
// Created by Alexander Fedosov on 22.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Show;

@protocol CMShowsListCollectionPresenterOutput <NSObject>

- (void)didSelectShow:(Show *)show;

@end