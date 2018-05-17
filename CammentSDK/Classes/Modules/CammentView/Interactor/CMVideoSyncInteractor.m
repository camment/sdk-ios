//
// Created by Alexander Fedosov on 14.05.2018.
//

#import "CMVideoSyncInteractor.h"
#import "CMShowMetadata.h"
#import "CMStore.h"
#import "CMAuthStatusChangedEventContext.h"
#import "DateTools.h"
#import "CMAPIIotInRequest.h"
#import "CMAPIDevcammentClient.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"
#import "CMNeededPlayerStateMessage.h"

@implementation CMVideoSyncInteractor {

}

- (void)requestNewShowTimestampIfNeeded:(NSString *)groupUuid {

    if (!groupUuid) { return; }

    CMAPIIotInRequest *iotInRequest = [CMAPIIotInRequest new];
    iotInRequest.type = @"need-player-state";
    NSError *error = nil;
    NSDictionary *jsonObject = @{
            @"groupUuid" : groupUuid,
    };
    NSData *data = [NSJSONSerialization dataWithJSONObject:
                    jsonObject
                                                   options:NULL
                                                     error:&error];
    iotInRequest.message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    if (error) {
        DDLogError(@"couldn't create json string with the object %@", jsonObject);
        return;
    }

    AWSTask *task = [[CMAPIDevcammentClient defaultAPIClient] usergroupsGroupUuidIotPost:groupUuid
                                                                                    body:iotInRequest];
    if (!task) {
        DDLogError(@"Couldn't create aws task to request new player state");
        return;
    }

    [task continueWithBlock:^id(AWSTask<id> *t) {
        if (t.error) {
            DDLogError(@"Failed to upload new video stream timing %@", t.error);
        }

        return nil;
    }];
}

- (void)updateVideoStreamStateIsPlaying:(BOOL)isPlaying show:(CMShowMetadata *)show timestamp:(NSTimeInterval)timestamp {
    CMAuthStatusChangedEventContext *authStatusChangedEventContext = [CMStore instance].authentificationStatusSubject.first;
    if (authStatusChangedEventContext.state != CMCammentUserAuthentificatedAsKnownUser) { return; }

    if (![authStatusChangedEventContext.user.cognitoUserId isEqualToString:[CMStore instance].activeGroup.hostCognitoUserId]) {
        return;
    }

    if (![CMStore instance].activeGroup) { return; }

    NSString *groupUuid = [CMStore instance].activeGroup.uuid;
    if (!groupUuid) { return; }

    if (isnan(timestamp)) {
        timestamp = 0;
    }

    NSDate *lastTimestampUploaded = [CMStore instance].lastTimestampUploaded;

    if (!isPlaying) {
        lastTimestampUploaded = nil;
    }

    if (!lastTimestampUploaded) {
        lastTimestampUploaded = [[NSDate alloc] initWithTimeIntervalSince1970:-1000];
    }

    NSDate *currentTimestamp = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp];

    double secs = [currentTimestamp secondsFrom:lastTimestampUploaded];
    if (ABS(secs) < 60) { return; }
    [CMStore instance].lastTimestampUploaded = isPlaying ? currentTimestamp : nil;

    CMAPIIotInRequest *iotInRequest = [CMAPIIotInRequest new];
    iotInRequest.type = @"player-state";
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                    @"isPlaying" : @(isPlaying),
                    @"groupUuid" : groupUuid,
                    @"timestamp" : @((int)timestamp),
            }
                                                   options:NULL
                                                     error:&error];
    iotInRequest.message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    AWSTask *task = [[CMAPIDevcammentClient defaultAPIClient] usergroupsGroupUuidIotPost:groupUuid
                                                                                    body:iotInRequest];
    if (!task) {
        DDLogError(@"Couldn't create aws task to upload new video stream timing");
        return;
    }

    [task continueWithBlock:^id(AWSTask<id> *t) {
        if (t.error) {
            DDLogError(@"Failed to upload new video stream timing %@", t.error);
        } else {
            DDLogInfo(@"Timestamp %d update", timestamp);
        }
        return nil;
    }];
}

- (void)requestNewTimestampsFromHostAppIfNeeded:(NSString *)groupUuid {
    CMAuthStatusChangedEventContext *authStatusChangedEventContext = [CMStore instance].authentificationStatusSubject.first;
    if (authStatusChangedEventContext.state != CMCammentUserAuthentificatedAsKnownUser) { return; }

    if (![CMStore instance].activeGroup) { return; }
    if (![CMStore instance].activeGroup.uuid) { return; }

    if (![[CMStore instance].activeGroup.uuid isEqualToString:groupUuid]) { return; }

    if (![authStatusChangedEventContext.user.cognitoUserId isEqualToString:[CMStore instance].activeGroup.hostCognitoUserId]) {
        return;
    }

    [[[CMStore instance] requestPlayerStateFromHostAppSignal] sendNext:@YES];
}

@end
