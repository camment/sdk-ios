//
// Created by Alexander Fedosov on 01.08.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMDisplayAlertViewControllerPresentationAction.h"
#import "CMPresentationInstructionOutput.h"

@interface CMDisplayAlertViewControllerPresentationAction ()
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, strong) NSDictionary *actions;
@end

@implementation CMDisplayAlertViewControllerPresentationAction {

}
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message actions:(NSDictionary<NSString *, id <CMPresentationRunableInterface>> *)actions {
    self = [super init];

    if (self) {
        self.title = title;
        self.message = message;
        self.actions = actions;
    }

    return self;
}

- (void)runWithOutput:(id <CMPresentationInstructionOutput>)output {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.title
                                                                             message:self.message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    for (NSString *actionTitle in self.actions.allKeys) {
        id value = self.actions[actionTitle];
        if (!value) {continue;}
        NSArray<id <CMPresentationRunableInterface>> *presentationActions = nil;
        if (![value isKindOfClass:[NSArray class]]) {
            presentationActions = @[value];
        } else {
            presentationActions = value;
        }


        [alertController addAction:[UIAlertAction actionWithTitle:actionTitle
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  for (id <CMPresentationRunableInterface> presentationAction in presentationActions) {
                                                                      [presentationAction runWithOutput:output];
                                                                  }
                                                              });

                                                          }]];
    }

    [output presentationInstruction:nil presentsViewController:alertController];
}


@end
