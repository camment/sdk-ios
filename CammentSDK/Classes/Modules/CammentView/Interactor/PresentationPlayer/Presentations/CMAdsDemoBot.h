//
// Created by Alexander Fedosov on 19.09.17.
//

#import <Foundation/Foundation.h>
#import "CMBot.h"

@protocol CMPresentationInstructionOutput;


static NSString *const kCMAdsDemoBotUUID = @"cmadsdemobot.camment.tv";

static NSString *const kCMAdsDemoBotOpenURLAction = @"cmadsdemobot.action.openURL";
static NSString *const kCMAdsDemoBotURLParam = @"cmadsdemobot.params.url";

@interface CMAdsDemoBot : NSObject<CMBot>

@property(nonatomic, weak) id <CMPresentationInstructionOutput> output;

@end