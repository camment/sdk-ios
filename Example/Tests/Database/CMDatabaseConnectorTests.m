//
// Created by Alexander Fedosov on 08/08/2018.
// Copyright (c) 2018 Alexander Fedosov. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <CammentSDK/CMDatabaseConnector.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <YapDatabase/YapDatabase.h>

#define LOG_LEVEL_DEF ddLogLevel
static const NSUInteger ddLogLevel = DDLogLevelAll;

SpecBegin(CMDatabaseConnectorTests)

    describe(@"Database connector", ^{

        beforeAll(^{
            [DDLog addLogger:[DDTTYLogger sharedInstance]];
            [[CMDatabaseConnector sharedInstance] setupDatabaseWithFilename:CMCammentDefaultDatabaseFilename];
        });

        afterAll(^{

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
            expect([CMDatabaseConnector sharedInstance]).toNot.beNil();
        });

        it(@"should open database file", ^{
            expect([CMDatabaseConnector sharedInstance].database).toNot.beNil();
        });

    });

SpecEnd


