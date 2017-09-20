//
//  CMGroupsListCMGroupsListPresenterOutput.h
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMGroupsListPresenterOutput <NSObject>

- (void)reloadData;
- (void)endRefreshing;

@end