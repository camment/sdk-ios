//
// Created by Alexander Fedosov on 08/08/2018.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

static NSString *const CMCammentDefaultDatabaseFilename = @"camment";

@class YapDatabase;

@interface CMDatabaseConnector : NSObject

@property(nonatomic, readonly) YapDatabase *database;
@property(nonatomic, readonly) RACSubject<NSNotification *> *databaseClosed;

+ (instancetype)sharedInstance;

- (NSString *)databasePathForFileName:(NSString *)filename;

- (void)setupDefaultDatabase;

- (void)closeAllConnections;

- (void)setupDatabaseWithFilename:(NSString *)filename;

@end