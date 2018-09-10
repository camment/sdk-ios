//
//  CMDisplayNode.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 10/09/2018.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface CMDisplayNode : ASDisplayNode

@property (nonatomic, assign) UIEdgeInsets calculatedSafeAreaInsets;

- (void)updateInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
