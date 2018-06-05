//
// Created by Alexander Fedosov on 05.06.2018.
//

#import <Foundation/Foundation.h>
#import "CMUserContants.h"


@interface CMUserCellViewModel : NSObject

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *onlineStatus;
@property (nonatomic, strong) NSString *blockStatus;
@property (nonatomic, assign) BOOL shouldDisplayBlockOptions;

- (instancetype)initWithUuid:(NSString *)uuid username:(NSString *)username avatar:(NSString *)avatar onlineStatus:(NSString *)onlineSatus blockStatus:(NSString *)blockStatus shouldDisplayBlockOptions:(BOOL)shouldDisplayBlockOptions;

+ (instancetype)modelWithUuid:(NSString *)uuid username:(NSString *)username avatar:(NSString *)avatar onlineStatus:(NSString *)onlineSatus blockStatus:(NSString *)blockStatus shouldDisplayBlockOptions:(BOOL)shouldDisplayBlockOptions;


@end