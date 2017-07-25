//
// Created by Alexander Fedosov on 25.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMNetworkObservableObject.h"
#import "CMConnectionReachability.h"


@interface CMNetworkObservableObject ()
@property(nonatomic) BOOL connectionAvailable;
@end

@implementation CMNetworkObservableObject

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
    }

    return self;
}

- (void)reachabilityChanged:(NSNotification *)reachabilityChanged {
    CMConnectionReachability *curReach = [reachabilityChanged object];
    if ([curReach isKindOfClass:[CMConnectionReachability class]]) {
        [self updateInterfaceWithReachability:curReach];
    }
}

- (void)updateInterfaceWithReachability:(CMConnectionReachability *)reachability {
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionAvailable = netStatus != NotReachable;
    if (connectionAvailable && connectionAvailable != self.connectionAvailable) {
        self.connectionAvailable = YES;
        [self networkDidBecomeAvailable];
    }
    self.connectionAvailable = connectionAvailable;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)networkDidBecomeAvailable {

}

@end