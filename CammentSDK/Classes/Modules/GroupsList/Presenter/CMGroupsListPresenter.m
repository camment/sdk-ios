//
//  CMGroupsListCMGroupsListPresenter.m
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMGroupsListPresenter.h"
#import "CMGroupsListWireframe.h"
#import "CMUsersGroup.h"
#import "CMStore.h"
#import "RACSubject.h"

@interface CMGroupsListPresenter ()
@property(nonatomic, strong) NSArray *groups;
@end

@implementation CMGroupsListPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.groups = [NSArray new];
        @weakify(self);
        [[RACObserve([CMStore instance], activeGroup) deliverOnMainThread] subscribeNext:^(CMUsersGroup *activeGroup) {
            @strongify(self);
            if (!self) { return; }
            [self reloadGroups];
        }];
    }
    
    return self;
}

- (void)setupView {
    [self reloadGroups];
}

- (NSInteger)groupsCount {
    return [self.groups count];
}

- (CMUsersGroup *)groupAtIndex:(NSInteger)index {
    return self.groups[(NSUInteger) index];
}

- (void)openGroupAtIndex:(NSInteger)index {
    CMUsersGroup *group = [self groupAtIndex:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectGroup:)]) {
        [self.delegate didSelectGroup:group];
    }
}

- (void)reloadGroups {
    [self.interactor fetchUserGroups];
}

- (void)didFetchUserGroups:(NSArray *)groups {
    self.groups = [NSArray arrayWithArray:groups];
    [self.output reloadData];
    [self.output endRefreshing];
}

- (void)didFailToFetchUserGroups:(NSError *)error {
    [self.output endRefreshing];
}

@end
