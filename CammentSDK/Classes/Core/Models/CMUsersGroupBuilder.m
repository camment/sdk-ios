#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMUsersGroup.h"
#import "CMUsersGroupBuilder.h"

@implementation CMUsersGroupBuilder
{
  NSString *_uuid;
  NSString *_showUuid;
  NSString *_ownerCognitoUserId;
  NSString *_hostCognitoUserId;
  NSString *_timestamp;
  NSString *_invitationLink;
  NSArray<CMUser *> *_users;
  BOOL _isPublic;
}

+ (instancetype)usersGroup
{
  return [[CMUsersGroupBuilder alloc] init];
}

+ (instancetype)usersGroupFromExistingUsersGroup:(CMUsersGroup *)existingUsersGroup
{
  return [[[[[[[[[CMUsersGroupBuilder usersGroup]
                 withUuid:existingUsersGroup.uuid]
                withShowUuid:existingUsersGroup.showUuid]
               withOwnerCognitoUserId:existingUsersGroup.ownerCognitoUserId]
              withHostCognitoUserId:existingUsersGroup.hostCognitoUserId]
             withTimestamp:existingUsersGroup.timestamp]
            withInvitationLink:existingUsersGroup.invitationLink]
           withUsers:existingUsersGroup.users]
          withIsPublic:existingUsersGroup.isPublic];
}

- (CMUsersGroup *)build
{
  return [[CMUsersGroup alloc] initWithUuid:_uuid showUuid:_showUuid ownerCognitoUserId:_ownerCognitoUserId hostCognitoUserId:_hostCognitoUserId timestamp:_timestamp invitationLink:_invitationLink users:_users isPublic:_isPublic];
}

- (instancetype)withUuid:(NSString *)uuid
{
  _uuid = [uuid copy];
  return self;
}

- (instancetype)withShowUuid:(NSString *)showUuid
{
  _showUuid = [showUuid copy];
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

- (instancetype)withUsers:(NSArray<CMUser *> *)users
{
  _users = [users copy];
  return self;
}

- (instancetype)withIsPublic:(BOOL)isPublic
{
  _isPublic = isPublic;
  return self;
}

@end

