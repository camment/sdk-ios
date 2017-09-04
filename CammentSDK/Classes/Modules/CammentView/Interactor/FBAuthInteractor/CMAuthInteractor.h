//
//  CMLoginCMLoginInteractor.h
//  Camment
//
//  Created by Alexander Fedosov on 17/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMAuthInteractorInput.h"
#import "CMAuthInteractorOutput.h"

@interface CMAuthInteractor : NSObject<CMAuthInteractorInput>

@property (nonatomic, weak) id<CMAuthInteractorOutput> output;

@end