#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMUsersGroup.h"
#import "CMUsersGroupBuilder.h"

@implementation CMUsersGroupBuilder
{
  NSString *_uuid;
  NSString *_ownerCognitoUserId;
  NSString *_timestamp;
}

+ (instancetype)usersGroup
{
  return [[CMUsersGroupBuilder alloc] init];
}

+ (instancetype)usersGroupFromExistingUsersGroup:(CMUsersGroup *)existingUsersGroup
{
  return [[[[CMUsersGroupBuilder usersGroup]
            withUuid:existingUsersGroup.uuid]
           withOwnerCognitoUserId:existingUsersGroup.ownerCognitoUserId]
          withTimestamp:existingUsersGroup.timestamp];
}

- (CMUsersGroup *)build
{
  return [[CMUsersGroup alloc] initWithUuid:_uuid ownerCognitoUserId:_ownerCognitoUserId timestamp:_timestamp];
}

- (instancetype)withUuid:(NSString *)uuid
{
  _uuid = [uuid copy];
  return self;
}

- (instancetype)withOwnerCognitoUserId:(NSString *)ownerCognitoUserId
{
  _ownerCognitoUserId = [ownerCognitoUserId copy];
  return self;
}

- (instancetype)withTimestamp:(NSString *)timestamp
{
  _timestamp = [timestamp copy];
  return self;
}

@end

