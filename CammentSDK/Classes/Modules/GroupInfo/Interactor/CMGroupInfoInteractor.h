//
//  CMGroupInfoCMGroupInfoInteractor.h
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMGroupInfoInteractorInput.h"
#import "CMGroupInfoInteractorOutput.h"

@interface CMGroupInfoInteractor : NSObject<CMGroupInfoInteractorInput>

@property (nonatomic, weak) id<CMGroupInfoInteractorOutput> output;

- (void)setActiveGroup:(NSString *)uuid;

- (void)unsetActiveGroup;
@end