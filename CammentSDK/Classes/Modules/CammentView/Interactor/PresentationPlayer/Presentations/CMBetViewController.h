//
// Created by Alexander Fedosov on 19.09.17.
//

#import <Foundation/Foundation.h>
#import "CMPresentableByPresentationAction.h"


@interface CMBetViewController : UIViewController<CMPresentableByPresentationAction>

- (instancetype)initWithSubject:(NSString *)subject;
+ (instancetype)controllerWithSubject:(NSString *)subject;


@end