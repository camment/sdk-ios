//
// Created by Alexander Fedosov on 05.06.2018.
//

#import "CMUserCellViewModel.h"


@implementation CMUserCellViewModel {

}

- (instancetype)initWithUuid:(NSString *)uuid username:(NSString *)username avatar:(NSString *)avatar onlineStatus:(NSString *)onlineSatus blockStatus:(NSString *)blockStatus shouldDisplayBlockOptions:(BOOL)shouldDisplayBlockOptions {
    self = [super init];
    if (self) {
        self.uuid = uuid;
        self.username = username;
        self.avatar = avatar;
        self.onlineStatus = onlineSatus;
        self.blockStatus = blockStatus;
        self.shouldDisplayBlockOptions = shouldDisplayBlockOptions;
    }

    return self;
}

+ (instancetype)modelWithUuid:(NSString *)uuid username:(NSString *)username avatar:(NSString *)avatar onlineStatus:(NSString *)onlineSatus blockStatus:(NSString *)blockStatus shouldDisplayBlockOptions:(BOOL)shouldDisplayBlockOptions {
    return [[self alloc] initWithUuid:uuid username:username avatar:avatar onlineStatus:onlineSatus blockStatus:blockStatus shouldDisplayBlockOptions:shouldDisplayBlockOptions];
}


- (BOOL)isEqual:(CMUserCellViewModel *)object
{
    if (self == object) {
        return YES;
    } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    return  (_uuid == object->_uuid ? YES : [_uuid isEqual:object->_uuid]) &&
            (_username == object->_username ? YES : [_username isEqual:object->_username]) &&
            (_avatar == object->_avatar ? YES : [_avatar isEqual:object->_avatar]) &&
            (_blockStatus == object->_blockStatus ? YES : [_blockStatus isEqual:object->_blockStatus]) &&
            (_onlineStatus == object->_onlineStatus ? YES : [_onlineStatus isEqual:object->_onlineStatus]) &&
            (_shouldDisplayBlockOptions == object->_shouldDisplayBlockOptions);
}

- (NSUInteger)hash {
    return [_uuid hash] ^ [_username hash] ^ [_avatar hash] ^ [_onlineStatus hash] ^ [_blockStatus hash] ^ (int)_shouldDisplayBlockOptions;
}

@end