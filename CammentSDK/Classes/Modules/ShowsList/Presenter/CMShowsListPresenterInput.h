//
//  CMShowsListCMShowsListPresenterInput.h
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol CMShowsListPresenterInput <NSObject>

- (void)setupView;

- (void)updateShows:(NSString *)passcode;

- (void)viewWantsRefreshShowList;
@end