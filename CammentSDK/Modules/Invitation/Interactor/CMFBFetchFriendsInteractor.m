//
// Created by Alexander Fedosov on 26.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMFBFetchFriendsInteractor.h"
#import "User.h"
#import "UserBuilder.h"
#import <ReactiveObjC.h>
#import <FBSDKGraphRequest.h>


@interface CMFBFetchFriendsInteractor ()

@property(nonatomic, strong) NSString *cursorAfter;
@property(nonatomic, assign) BOOL isFinished;


@end

@implementation CMFBFetchFriendsInteractor {

}
- (RACSignal<NSArray<User *> *> *)fetchFriendList:(BOOL)resetPaginationContext {

    if (resetPaginationContext) {
        self.isFinished = NO;
        self.cursorAfter = nil;
    }

    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {

        NSMutableDictionary *params = [NSMutableDictionary new];
        params[@"limit"] = @40;
        params[@"fields"] = @"id,name";
        if (self.cursorAfter) {
            params[@"after"] = self.cursorAfter;
        }

        FBSDKGraphRequest * request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends"
                                          parameters:params];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (error) {
                [subscriber sendError: error];
            } else {
                NSArray<NSDictionary *> *friends = [result valueForKey:@"data"] ?: @[];
                NSDictionary *paging = [result valueForKey:@"paging"];
                NSDictionary *cursors = [paging valueForKey:@"cursors"];
                self.cursorAfter = [cursors valueForKey:@"after"];
                self.isFinished = self.cursorAfter == nil;

                NSArray<User *> *users = [friends.rac_sequence map:^User *(NSDictionary *value) {
                    return [[[[[UserBuilder new]
                            withUsername:value[@"name"]]
                            withFbUserId:value[@"id"]]
                            withUserPhoto:[[@"https://graph.facebook.com/v2.5/" stringByAppendingString:value[@"id"]] stringByAppendingString:@"/picture?type=normal"]] build];
                }].array;
                [subscriber sendNext:users];
                [subscriber sendCompleted];
            }
        }];

        return nil;
    }];
}

- (BOOL)isFinished {
    return _isFinished;
}

@end