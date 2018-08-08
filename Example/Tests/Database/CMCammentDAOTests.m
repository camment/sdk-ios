//
// Created by Alexander Fedosov on 08/08/2018.
// Copyright (c) 2018 Alexander Fedosov. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <CammentSDK/CMCammentDAO.h>
#import <CammentSDK/CMCamment.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <YapDatabase/YapDatabase.h>
#import <CammentSDK/CMDatabaseConnector.h>

#define LOG_LEVEL_DEF ddLogLevel
static const NSUInteger ddLogLevel = DDLogLevelAll;

SpecBegin(CMCammentDAOTests)

    __block CMCammentDAO *cammentDAO;

    describe(@"CammentDAO", ^{

        beforeAll(^{
            [DDLog addLogger:[DDTTYLogger sharedInstance]];
            [[CMDatabaseConnector sharedInstance] setupDatabaseWithFilename:CMCammentDefaultDatabaseFilename];
            cammentDAO = [[CMCammentDAO alloc] initWithDatabase:[CMDatabaseConnector sharedInstance].database];
        });

        afterAll(^{
            cammentDAO = nil;
            [[CMDatabaseConnector sharedInstance] closeAllConnections];

            NSMutableArray *filesToRemove = [NSMutableArray new];

            NSString *yapDatabasePath = [[CMDatabaseConnector sharedInstance] databasePathForFileName:CMCammentDefaultDatabaseFilename];
            if (yapDatabasePath) {[filesToRemove addObject:yapDatabasePath];}

            NSString *yapDatabaseWalPath = [yapDatabasePath stringByAppendingString:@"-wal"];
            if (yapDatabaseWalPath) {[filesToRemove addObject:yapDatabaseWalPath];}

            NSString *yapDatabaseShmPath = [yapDatabasePath stringByAppendingString:@"-shm"];
            if (yapDatabaseShmPath) {[filesToRemove addObject:yapDatabaseShmPath];}

            for (NSString *path in filesToRemove) {
                DDLogInfo(@"Removing file %@..", path);
                NSError *error = nil;
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                if (error) {
                    DDLogError(@"Couldn't delete database file %@", error);
                }
            }

        });

        it(@"should be created", ^{
            expect(cammentDAO).toNot.beNil();
        });

        it(@"should save camment", ^{
            // Save camment
            NSURL * testCammentURL = [[NSBundle mainBundle] URLForResource:@"test-camment.mp4" withExtension:@""];
            expect(testCammentURL).toNot.beNil();
            
            CMCamment *cammentToSave = [[CMCamment alloc] initWithShowUuid:@"showUUID"
                                                             userGroupUuid:@"usergroupUUID"
                                                                      uuid:@"uuid"
                                                                 remoteURL:@"remoteURL"
                                                                  localURL:[testCammentURL absoluteString]
                                                              thumbnailURL:@"thumbnailUR:"
                                                     userCognitoIdentityId:@"userCognitoIdentityId"
                                                                    showAt:@(120)
                                                               isMadeByBot:YES
                                                                   botUuid:@"botUUID"
                                                                 botAction:@"botAction"
                                                                 isDeleted:YES
                                                           shouldBeDeleted:YES
                                                                    status:[[CMCammentStatus alloc] initWithDeliveryStatus:CMCammentDeliveryStatusDelivered
                                                                                                                 isWatched:YES]];

            waitUntil(^(DoneCallback done) {
                [[cammentDAO saveEntity:cammentToSave] continueWithBlock:^id(BFTask <CMCamment *> *t) {
                    expect(t.result).toNot.beNil();
                    done();
                    return nil;
                }];
            });

            waitUntil(^(DoneCallback done) {
                [[cammentDAO entityWithId:cammentToSave.uuid] continueWithBlock:^id(BFTask <CMCamment *> *t) {
                    expect(t.result).toNot.beNil();
                    expect(t.result).equal(cammentToSave);
                    done();
                    return nil;
                }];
            });

        });

    });

SpecEnd


