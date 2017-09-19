//
// Created by Alexander Fedosov on 19.09.17.
//

#import "CMBotAction.h"


@implementation CMBotAction {

}
- (id)copyWithZone:(NSZone *)zone {
    CMBotAction *action = [[[self class] allocWithZone:zone] init];
    if(action) {
        action.botUuid = self.botUuid;
        action.action = self.action;
        action.params = self.params;
    }
    return action;
}

@end
