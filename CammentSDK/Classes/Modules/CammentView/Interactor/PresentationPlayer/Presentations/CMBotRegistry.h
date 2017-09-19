//
// Created by Alexander Fedosov on 19.09.17.
//

#import <Foundation/Foundation.h>

@protocol CMBot;
@class CMBotAction;
@protocol CMPresentationInstructionOutput;


@interface CMBotRegistry : NSObject

@property (nonatomic, readonly) NSMutableArray<id<CMBot>> *bots;

- (void)addBot:(id<CMBot>)bot;
- (void)removeBot:(id<CMBot>)bot;
- (void)runAction:(CMBotAction *)action;
- (void)updateBotsOutputInterface:(id<CMPresentationInstructionOutput>)output;

@end