//
// Created by Alexander Fedosov on 19.09.17.
//

#import <Foundation/Foundation.h>
#import "CMBot.h"

@protocol CMPresentationInstructionOutput;


static NSString *const kCMAdsDemoBotUUID = @"cmadsdemobot.camment.tv";

static NSString *const kCMAdsDemoBotOpenURLAction = @"cmadsdemobot.action.openURL";
static NSString *const kCMAdsDemoBotPlayVideoAction = @"cmadsdemobot.action.playVideo";

static NSString *const kCMAdsDemoBotURLParam = @"cmadsdemobot.params.url";
static NSString *const kCMAdsDemoBotVideoURLParam = @"cmadsdemobot.params.videoUrl";
static NSString *const kCMAdsDemoBotPlaceholderURLParam = @"cmadsdemobot.params.placeholderUrl";
static NSString *const kCMAdsDemoBotVideoOnClickPresentationInstructionParam = @"cmadsdemobot.params.videoOnClick";
static NSString *const kCMAdsDemoBotRectParam = @"cmadsdemobot.params.rect";

@interface CMAdsDemoBot : NSObject<CMBot>

@property(nonatomic, weak) id <CMPresentationInstructionOutput> output;

@end