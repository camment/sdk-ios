//
//  CMErrorPresenter.m
//  sendy
//
//  Created by Alexander Fedosov on 04.11.15.
//  Copyright © 2015 Alexander Fedosov. All rights reserved.
//

#import "CMErrorPresenter.h"

@implementation CMErrorPresenter

- (void)loadView{

    [self.viewInterface setErrorMessage:[self.error localizedDescription]];
    [self.viewInterface setErrorTitle:CMLocalized(@"Error")];
}

@end
