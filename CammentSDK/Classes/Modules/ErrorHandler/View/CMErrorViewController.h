//
//  CMErrorViewController.h
//  sendy
//
//  Created by Alexander Fedosov on 04.11.15.
//  Copyright © 2015 Alexander Fedosov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMErrorPresenterInterface.h"
#import "CMErrorViewInterface.h"

@interface CMErrorViewController : UIAlertController<CMErrorViewInterface>

@property (nonatomic, strong) id<CMErrorPresenterInterface> presenter;

@end
