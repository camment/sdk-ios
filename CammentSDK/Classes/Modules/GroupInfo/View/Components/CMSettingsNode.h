//
// Created by Alexander Fedosov on 17.10.2017.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMSettingsNode;

@protocol CMSettingsNodeDelegate<NSObject>

-(void)settingsNodeDidCloseSettingsView:(CMSettingsNode *)node;
-(void)settingsNodeDidLogout:(CMSettingsNode *)node;
-(void)settingsNodeDidLeaveTheGroup:(CMSettingsNode *)node;

@end

@interface CMSettingsNode : ASDisplayNode

@property(nonatomic, weak) id<CMSettingsNodeDelegate> delegate;
@property(nonatomic, assign) BOOL shouldDisplayLeaveGroup;

@end