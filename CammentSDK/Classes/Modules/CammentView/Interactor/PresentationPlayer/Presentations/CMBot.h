//
// Created by Alexander Fedosov on 19.09.17.
//

#import <Foundation/Foundation.h>
#import "CMPresentationInstructionOutput.h"

@class CMBotAction;

@protocol CMBot <NSObject>

- (NSString *)uuid;
- (BOOL)canRunAction:(CMBotAction *)action;
- (void)runAction:(CMBotAction *)action;
- (void)setOutput:(id <CMPresentationInstructionOutput>)output;

@end