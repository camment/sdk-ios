#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMUsersGroup.h"
#import "CMUsersGroupBuilder.h"

@implementation CMUsersGroupBuilder
{
  NSString *_uuid;
  NSString *_ownerCognitoUserId;
  NSString *_hostCognitoUserId;
  NSString *_timestamp;
  NSString *_invitationLink;
}

+ (instancetype)usersGroup
{
  return [[CMUsersGroupBuilder alloc] init];
}

+ (instancetype)usersGroupFromExistingUsersGroup:(CMUsersGroup *)existingUsersGroup
{
  return [[[[[[CMUsersGroupBuilder usersGroup]
              withUuid:existingUsersGroup.uuid]
             withOwnerCognitoUserId:existingUsersGroup.ownerCognitoUserId]
            withHostCognitoUserId:existingUsersGroup.hostCognitoUserId]
           withTimestamp:existingUsersGroup.timestamp]
          withInvitationLink:existingUsersGroup.invitationLink];
}

- (CMUsersGroup *)build
{
  return [[CMUsersGroup alloc] initWithUuid:_uuid ownerCognitoUserId:_ownerCognitoUserId hostCognitoUserId:_hostCognitoUserId timestamp:_timestamp invitationLink:_invitationLink];
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

- (instancetype)withHostCognitoUserId:(NSString *)hostCognitoUserId
{
  _hostCognitoUserId = [hostCognitoUserId copy];
  return self;
}

- (instancetype)withTimestamp:(NSString *)timestamp
{
  _timestamp = [timestamp copy];
  return self;
}

- (instancetype)withInvitationLink:(NSString *)invitationLink
{
  _invitationLink = [invitationLink copy];
  return self;
}

@end

