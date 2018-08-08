//
// Created by Alexander Fedosov on 08/08/2018.
//

#import "CMDatabaseConnector.h"
#import "NSNotificationCenter+RACSupport.h"
#import "RACSignal+Operations.h"
#import "NSObject+RACDeallocating.h"
#import "CMYapDatabaseSerializers.h"
#import <YapDatabase/YapDatabase.h>

@implementation CMDatabaseConnector {

}

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _databaseClosed = [RACSubject new];

        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:YapDatabaseClosedNotification
                                                                object:nil]
          takeUntil:self.rac_willDeallocSignal]
                subscribeNext:^(NSNotification *x) {
                    [self.databaseClosed sendNext:x];
                }];
    }

    return self;
}


- (NSString *)databasePathForFileName:(NSString *)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? paths[0] : NSTemporaryDirectory();

    NSString *databaseName = [filename stringByAppendingString:@".sqlite"];

    return [baseDir stringByAppendingPathComponent:databaseName];
}

- (void)setupDatabaseWithFilename:(NSString *)filename {

    NSString *databasePath = [self databasePathForFileName:filename];
    _database = [[YapDatabase alloc] initWithPath:databasePath
            serializer:[CMYapDatabaseSerializers defaultSerializer]
            deserializer:[CMYapDatabaseSerializers defaultDeserializer]];

    // Skip iCloud backup
    NSURL *databaseURL = [NSURL fileURLWithPath:databasePath];
    NSError *error = nil;
    BOOL success = [databaseURL setResourceValue:@YES
                                          forKey: NSURLIsExcludedFromBackupKey
                                           error: &error];
    if(!success){
        DDLogError(@"Error excluding %@ from backup %@", [databaseURL lastPathComponent], error);
    }
}

- (void)setupDefaultDatabase {
    [self setupDatabaseWithFilename:CMCammentDefaultDatabaseFilename];
}

- (void)closeAllConnections {
    _database = nil;
}

@end
