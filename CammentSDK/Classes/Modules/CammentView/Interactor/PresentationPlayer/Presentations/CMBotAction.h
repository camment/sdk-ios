//
// Created by Alexander Fedosov on 19.09.17.
//

#import <Foundation/Foundation.h>


@interface CMBotAction : NSObject<NSCopying>

@property (nonatomic, copy) NSString *botUuid;
@property (nonatomic, copy) NSString *action;
@property (nonatomic) id params;

@end
