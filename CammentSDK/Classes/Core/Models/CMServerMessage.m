/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMServerMessage.adtValue
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMServerMessage.h"

typedef NS_ENUM(NSUInteger, _CMServerMessageSubtypes) {
  _CMServerMessageSubtypescamment,
  _CMServerMessageSubtypesuserJoined,
  _CMServerMessageSubtypescammentDeleted,
  _CMServerMessageSubtypesmembershipAccepted,
  _CMServerMessageSubtypesuserRemoved,
  _CMServerMessageSubtypescammentDelivered,
  _CMServerMessageSubtypesad,
  _CMServerMessageSubtypesuserGroupStatusChanged,
  _CMServerMessageSubtypesplayerState,
  _CMServerMessageSubtypesneededPlayerState,
  _CMServerMessageSubtypesnewGroupHost
};

@implementation CMServerMessage
{
  _CMServerMessageSubtypes _subtype;
  CMCamment *_camment_camment;
  CMUserJoinedMessage *_userJoined_userJoinedMessage;
  CMCammentDeletedMessage *_cammentDeleted_cammentDeletedMessage;
  CMMembershipAcceptedMessage *_membershipAccepted_membershipAcceptedMessage;
  CMUserRemovedMessage *_userRemoved_userRemovedMessage;
  CMCammentDeliveredMessage *_cammentDelivered_cammentDelivered;
  CMAdBanner *_ad_adBanner;
  CMUserGroupStatusChangedMessage *_userGroupStatusChanged_userGroupStatusChangedMessage;
  CMNewPlayerStateMessage *_playerState_message;
  CMNeededPlayerStateMessage *_neededPlayerState_message;
  CMNewGroupHostMessage *_newGroupHost_message;
}

+ (instancetype)adWithAdBanner:(CMAdBanner *)adBanner
{
  CMServerMessage *object = [[CMServerMessage alloc] init];
  object->_subtype = _CMServerMessageSubtypesad;
  object->_ad_adBanner = adBanner;
  return object;
}

+ (instancetype)cammentDeletedWithCammentDeletedMessage:(CMCammentDeletedMessage *)cammentDeletedMessage
{
  CMServerMessage *object = [[CMServerMessage alloc] init];
  object->_subtype = _CMServerMessageSubtypescammentDeleted;
  object->_cammentDeleted_cammentDeletedMessage = cammentDeletedMessage;
  return object;
}

+ (instancetype)cammentDeliveredWithCammentDelivered:(CMCammentDeliveredMessage *)cammentDelivered
{
  CMServerMessage *object = [[CMServerMessage alloc] init];
  object->_subtype = _CMServerMessageSubtypescammentDelivered;
  object->_cammentDelivered_cammentDelivered = cammentDelivered;
  return object;
}

+ (instancetype)cammentWithCamment:(CMCamment *)camment
{
  CMServerMessage *object = [[CMServerMessage alloc] init];
  object->_subtype = _CMServerMessageSubtypescamment;
  object->_camment_camment = camment;
  return object;
}

+ (instancetype)membershipAcceptedWithMembershipAcceptedMessage:(CMMembershipAcceptedMessage *)membershipAcceptedMessage
{
  CMServerMessage *object = [[CMServerMessage alloc] init];
  object->_subtype = _CMServerMessageSubtypesmembershipAccepted;
  object->_membershipAccepted_membershipAcceptedMessage = membershipAcceptedMessage;
  return object;
}

+ (instancetype)neededPlayerStateWithMessage:(CMNeededPlayerStateMessage *)message
{
  CMServerMessage *object = [[CMServerMessage alloc] init];
  object->_subtype = _CMServerMessageSubtypesneededPlayerState;
  object->_neededPlayerState_message = message;
  return object;
}

+ (instancetype)newGroupHostWithMessage:(CMNewGroupHostMessage *)message
{
  CMServerMessage *object = [[CMServerMessage alloc] init];
  object->_subtype = _CMServerMessageSubtypesnewGroupHost;
  object->_newGroupHost_message = message;
  return object;
}

+ (instancetype)playerStateWithMessage:(CMNewPlayerStateMessage *)message
{
  CMServerMessage *object = [[CMServerMessage alloc] init];
  object->_subtype = _CMServerMessageSubtypesplayerState;
  object->_playerState_message = message;
  return object;
}

+ (instancetype)userGroupStatusChangedWithUserGroupStatusChangedMessage:(CMUserGroupStatusChangedMessage *)userGroupStatusChangedMessage
{
  CMServerMessage *object = [[CMServerMessage alloc] init];
  object->_subtype = _CMServerMessageSubtypesuserGroupStatusChanged;
  object->_userGroupStatusChanged_userGroupStatusChangedMessage = userGroupStatusChangedMessage;
  return object;
}

+ (instancetype)userJoinedWithUserJoinedMessage:(CMUserJoinedMessage *)userJoinedMessage
{
  CMServerMessage *object = [[CMServerMessage alloc] init];
  object->_subtype = _CMServerMessageSubtypesuserJoined;
  object->_userJoined_userJoinedMessage = userJoinedMessage;
  return object;
}

+ (instancetype)userRemovedWithUserRemovedMessage:(CMUserRemovedMessage *)userRemovedMessage
{
  CMServerMessage *object = [[CMServerMessage alloc] init];
  object->_subtype = _CMServerMessageSubtypesuserRemoved;
  object->_userRemoved_userRemovedMessage = userRemovedMessage;
  return object;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  switch (_subtype) {
    case _CMServerMessageSubtypescamment: {
      return [NSString stringWithFormat:@"%@ - camment \n\t camment: %@; \n", [super description], _camment_camment];
      break;
    }
    case _CMServerMessageSubtypesuserJoined: {
      return [NSString stringWithFormat:@"%@ - userJoined \n\t userJoinedMessage: %@; \n", [super description], _userJoined_userJoinedMessage];
      break;
    }
    case _CMServerMessageSubtypescammentDeleted: {
      return [NSString stringWithFormat:@"%@ - cammentDeleted \n\t cammentDeletedMessage: %@; \n", [super description], _cammentDeleted_cammentDeletedMessage];
      break;
    }
    case _CMServerMessageSubtypesmembershipAccepted: {
      return [NSString stringWithFormat:@"%@ - membershipAccepted \n\t membershipAcceptedMessage: %@; \n", [super description], _membershipAccepted_membershipAcceptedMessage];
      break;
    }
    case _CMServerMessageSubtypesuserRemoved: {
      return [NSString stringWithFormat:@"%@ - userRemoved \n\t userRemovedMessage: %@; \n", [super description], _userRemoved_userRemovedMessage];
      break;
    }
    case _CMServerMessageSubtypescammentDelivered: {
      return [NSString stringWithFormat:@"%@ - cammentDelivered \n\t cammentDelivered: %@; \n", [super description], _cammentDelivered_cammentDelivered];
      break;
    }
    case _CMServerMessageSubtypesad: {
      return [NSString stringWithFormat:@"%@ - ad \n\t adBanner: %@; \n", [super description], _ad_adBanner];
      break;
    }
    case _CMServerMessageSubtypesuserGroupStatusChanged: {
      return [NSString stringWithFormat:@"%@ - userGroupStatusChanged \n\t userGroupStatusChangedMessage: %@; \n", [super description], _userGroupStatusChanged_userGroupStatusChangedMessage];
      break;
    }
    case _CMServerMessageSubtypesplayerState: {
      return [NSString stringWithFormat:@"%@ - playerState \n\t message: %@; \n", [super description], _playerState_message];
      break;
    }
    case _CMServerMessageSubtypesneededPlayerState: {
      return [NSString stringWithFormat:@"%@ - neededPlayerState \n\t message: %@; \n", [super description], _neededPlayerState_message];
      break;
    }
    case _CMServerMessageSubtypesnewGroupHost: {
      return [NSString stringWithFormat:@"%@ - newGroupHost \n\t message: %@; \n", [super description], _newGroupHost_message];
      break;
    }
  }
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {_subtype, [_camment_camment hash], [_userJoined_userJoinedMessage hash], [_cammentDeleted_cammentDeletedMessage hash], [_membershipAccepted_membershipAcceptedMessage hash], [_userRemoved_userRemovedMessage hash], [_cammentDelivered_cammentDelivered hash], [_ad_adBanner hash], [_userGroupStatusChanged_userGroupStatusChangedMessage hash], [_playerState_message hash], [_neededPlayerState_message hash], [_newGroupHost_message hash]};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 12; ++ii) {
    unsigned long long base = (((unsigned long long)result) << 32 | subhashes[ii]);
    base = (~base) + (base << 18);
    base ^= (base >> 31);
    base *=  21;
    base ^= (base >> 11);
    base += (base << 6);
    base ^= (base >> 22);
    result = base;
  }
  return result;
}

- (BOOL)isEqual:(CMServerMessage *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    _subtype == object->_subtype &&
    (_newGroupHost_message == object->_newGroupHost_message ? YES : [_newGroupHost_message isEqual:object->_newGroupHost_message]) &&
    (_userJoined_userJoinedMessage == object->_userJoined_userJoinedMessage ? YES : [_userJoined_userJoinedMessage isEqual:object->_userJoined_userJoinedMessage]) &&
    (_cammentDeleted_cammentDeletedMessage == object->_cammentDeleted_cammentDeletedMessage ? YES : [_cammentDeleted_cammentDeletedMessage isEqual:object->_cammentDeleted_cammentDeletedMessage]) &&
    (_membershipAccepted_membershipAcceptedMessage == object->_membershipAccepted_membershipAcceptedMessage ? YES : [_membershipAccepted_membershipAcceptedMessage isEqual:object->_membershipAccepted_membershipAcceptedMessage]) &&
    (_userRemoved_userRemovedMessage == object->_userRemoved_userRemovedMessage ? YES : [_userRemoved_userRemovedMessage isEqual:object->_userRemoved_userRemovedMessage]) &&
    (_camment_camment == object->_camment_camment ? YES : [_camment_camment isEqual:object->_camment_camment]) &&
    (_ad_adBanner == object->_ad_adBanner ? YES : [_ad_adBanner isEqual:object->_ad_adBanner]) &&
    (_userGroupStatusChanged_userGroupStatusChangedMessage == object->_userGroupStatusChanged_userGroupStatusChangedMessage ? YES : [_userGroupStatusChanged_userGroupStatusChangedMessage isEqual:object->_userGroupStatusChanged_userGroupStatusChangedMessage]) &&
    (_playerState_message == object->_playerState_message ? YES : [_playerState_message isEqual:object->_playerState_message]) &&
    (_neededPlayerState_message == object->_neededPlayerState_message ? YES : [_neededPlayerState_message isEqual:object->_neededPlayerState_message]) &&
    (_cammentDelivered_cammentDelivered == object->_cammentDelivered_cammentDelivered ? YES : [_cammentDelivered_cammentDelivered isEqual:object->_cammentDelivered_cammentDelivered]);
}

- (void)matchCamment:(CMServerMessageCammentMatchHandler)cammentMatchHandler userJoined:(CMServerMessageUserJoinedMatchHandler)userJoinedMatchHandler cammentDeleted:(CMServerMessageCammentDeletedMatchHandler)cammentDeletedMatchHandler membershipAccepted:(CMServerMessageMembershipAcceptedMatchHandler)membershipAcceptedMatchHandler userRemoved:(CMServerMessageUserRemovedMatchHandler)userRemovedMatchHandler cammentDelivered:(CMServerMessageCammentDeliveredMatchHandler)cammentDeliveredMatchHandler ad:(CMServerMessageAdMatchHandler)adMatchHandler userGroupStatusChanged:(CMServerMessageUserGroupStatusChangedMatchHandler)userGroupStatusChangedMatchHandler playerState:(CMServerMessagePlayerStateMatchHandler)playerStateMatchHandler neededPlayerState:(CMServerMessageNeededPlayerStateMatchHandler)neededPlayerStateMatchHandler newGroupHost:(CMServerMessageNewGroupHostMatchHandler)newGroupHostMatchHandler
{
  switch (_subtype) {
    case _CMServerMessageSubtypescamment: {
      cammentMatchHandler(_camment_camment);
      break;
    }
    case _CMServerMessageSubtypesuserJoined: {
      userJoinedMatchHandler(_userJoined_userJoinedMessage);
      break;
    }
    case _CMServerMessageSubtypescammentDeleted: {
      cammentDeletedMatchHandler(_cammentDeleted_cammentDeletedMessage);
      break;
    }
    case _CMServerMessageSubtypesmembershipAccepted: {
      membershipAcceptedMatchHandler(_membershipAccepted_membershipAcceptedMessage);
      break;
    }
    case _CMServerMessageSubtypesuserRemoved: {
      userRemovedMatchHandler(_userRemoved_userRemovedMessage);
      break;
    }
    case _CMServerMessageSubtypescammentDelivered: {
      cammentDeliveredMatchHandler(_cammentDelivered_cammentDelivered);
      break;
    }
    case _CMServerMessageSubtypesad: {
      adMatchHandler(_ad_adBanner);
      break;
    }
    case _CMServerMessageSubtypesuserGroupStatusChanged: {
      userGroupStatusChangedMatchHandler(_userGroupStatusChanged_userGroupStatusChangedMessage);
      break;
    }
    case _CMServerMessageSubtypesplayerState: {
      playerStateMatchHandler(_playerState_message);
      break;
    }
    case _CMServerMessageSubtypesneededPlayerState: {
      neededPlayerStateMatchHandler(_neededPlayerState_message);
      break;
    }
    case _CMServerMessageSubtypesnewGroupHost: {
      newGroupHostMatchHandler(_newGroupHost_message);
      break;
    }
  }
}

@end

