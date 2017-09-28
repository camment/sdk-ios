//
// Created by Alexander Fedosov on 28.09.2017.
//

#import "CMWaitContentNode.h"
#import "ASTextNode.h"
#import "DateTools.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>


@interface CMWaitContentNode ()

@property(nonatomic, strong) ASTextNode *textNode;

@end

@implementation CMWaitContentNode

- (instancetype)init {
    return [self initWithStartDate:[NSDate date]];
}

- (instancetype)initWithStartDate:(NSDate *)date {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.debugName = @"CMStreamPlayerNode";
        self.textNode = [ASTextNode new];

        NSString *dateText = [NSString stringWithFormat:@"Stream starts at %@", [date formattedDateWithFormat:@"HH:mm"]];
        self.textNode.attributedText = [[NSAttributedString alloc] initWithString:dateText
                                                                       attributes:@{
                                                                          NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                       }];
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)openContentAtUrl:(NSURL *)url {
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY
                                                      sizingOptions:ASCenterLayoutSpecSizingOptionDefault
                                                              child:_textNode];
}

@end