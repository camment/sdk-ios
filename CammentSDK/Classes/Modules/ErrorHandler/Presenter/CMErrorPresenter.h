//
//  CMErrorPresenter.h
//  sendy
//
//  Created by Alexander Fedosov on 04.11.15.
//  Copyright © 2015 Alexander Fedosov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMErrorWireframe.h"
#import "CMErrorPresenterInterface.h"
#import "CMErrorViewInterface.h"

@interface CMErrorPresenter : NSObject<CMErrorPresenterInterface>

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) CMErrorWireframe *wireframe;
@property (nonatomic, weak) id<CMErrorViewInterface> viewInterface;

@end
