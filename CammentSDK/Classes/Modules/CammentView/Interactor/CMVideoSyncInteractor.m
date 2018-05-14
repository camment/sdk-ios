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

@implementation CMVideoSyncInteractor {

}

- (void)requestNewShowTimestampIfNeeded {
// send message requesting new timestamp
}

- (void)updateVideoStreamStateIsPlaying:(BOOL)isPlaying show:(CMShowMetadata *)show timestamp:(NSTimeInterval)timestamp {
    if (![CMStore instance].activeGroup) { return; }

    NSString *groupOwner = [CMStore instance].activeGroup.ownerCognitoUserId;
    if (!groupOwner) { return; }

    NSString *groupUuid = [CMStore instance].activeGroup.uuid;
    if (!groupUuid) { return; }

    if (isnan(timestamp)) {
        timestamp = 0;
    }

    CMAuthStatusChangedEventContext *authStatusChangedEventContext = [CMStore instance].authentificationStatusSubject.first;

    if (![authStatusChangedEventContext.user.cognitoUserId isEqualToString:groupOwner]) {
        return;
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
    if (ABS(secs) < 10) { return; }
    [CMStore instance].lastTimestampUploaded = isPlaying ? currentTimestamp : nil;

    CMAPIIotInRequest *iotInRequest = [CMAPIIotInRequest new];
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                    @"event" : @"timestamp",
                    @"isPlaying" : @(isPlaying),
                    @"showUuid" : show.uuid ?: @"",
                    @"groupUuid" : groupUuid,
                    @"timestamp" : @(timestamp),
            }
                                                   options:NSJSONWritingPrettyPrinted
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

@end