//
//  CMShowsListCMShowsListPresenterOutput.h
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMShowsListNodeDelegate;

@protocol CMShowsListPresenterOutput <NSObject>

- (void)setCammentsBlockNodeDelegate:(id<CMShowsListNodeDelegate>)delegate;

- (void)setLoadingIndicator;

- (void)hideLoadingIndicator;

- (void)setCurrentBroadcasterPasscode:(NSString *)passcode;
@end