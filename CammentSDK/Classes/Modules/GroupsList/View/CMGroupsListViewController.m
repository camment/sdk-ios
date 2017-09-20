//
//  CMGroupsListCMGroupsListViewController.m
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "ASCollectionNode.h"
#import "ASTableNode.h"
#import "CMGroupsListViewController.h"
#import "CMUsersGroup.h"
#import "CMGroupCellNode.h"


@interface CMGroupsListViewController () <ASTableDelegate, ASTableDataSource>
@end

@implementation CMGroupsListViewController

- (instancetype)init {
    self = [super initWithNode:[CMGroupsListNode new]];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.node.refreshControl addTarget:self
                                 action:@selector(reload)
                       forControlEvents:UIControlEventValueChanged];

    self.node.tableNode.delegate = self;
    self.node.tableNode.dataSource = self;

    [self.presenter setupView];
}

- (void)reload {
    [self.presenter reloadGroups];
}

- (void)reloadData {
    [self.node.tableNode reloadData];
}

- (void)endRefreshing {
    [self.node.refreshControl endRefreshing];
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.presenter openGroupAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return [self.presenter groupsCount];
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMUsersGroup *group = [self.presenter groupAtIndex:indexPath.row];
    return ^ASCellNode * {
        return [[CMGroupCellNode alloc] initWithGroup:group];
    };
}


@end
