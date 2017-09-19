//
// Created by Alexander Fedosov on 19.09.17.
//

#import <Foundation/Foundation.h>
#import "CMBot.h"


static NSString *const kCMPresentationPlayerBotUUID = @"presentationplayerbot.camment.tv";
static NSString *const kCMPresentationPlayerBotRunableParam= @"presentationplayerbot.params.runable";
static NSString *const kCMPresentationPlayerBotPlayAction= @"presentationplayerbot.action.play";

@interface CMPresentationPlayerBot : NSObject<CMBot>
@property(nonatomic, weak) id <CMPresentationInstructionOutput> output;
@end