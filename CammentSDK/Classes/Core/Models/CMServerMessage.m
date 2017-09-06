/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMServerMessage.adtValue
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMServerMessage.h"

typedef NS_ENUM(NSUInteger, _CMServerMessageSubtypes) {
  _CMServerMessageSubtypesinvitation,
  _CMServerMessageSubtypescamment,
  _CMServerMessageSubtypesuserJoined,
  _CMServerMessageSubtypescammentDeleted,
  _CMServerMessageSubtypesmembershipRequest,
  _CMServerMessageSubtypesmembershipAccepted
};

@implementation CMServerMessage
{
  _CMServerMessageSubtypes _subtype;
  CMInvitation *_invitation_invitation;
  CMCamment *_camment_camment;
  CMUserJoinedMessage *_userJoined_userJoinedMessage;
  CMCammentDeletedMessage *_cammentDeleted_cammentDeletedMessage;
  CMMembershipRequestMessage *_membershipRequest_membershipRequestMessage;
  CMMembershipAcceptedMessage *_membershipAccepted_membershipAcceptedMessage;
}

+ (instancetype)cammentDeletedWithCammentDeletedMessage:(CMCammentDeletedMessage *)cammentDeletedMessage
{
  CMServerMessage *object = [[CMServerMessage alloc] init];
  object->_subtype = _CMServerMessageSubtypescammentDeleted;
  object->_cammentDeleted_cammentDeletedMessage = cammentDeletedMessage;
  return object;
}

+ (instancetype)cammentWithCamment:(CMCamment *)camment
{
  CMServerMessage *object = [[CMServerMessage alloc] init];
  object->_subtype = _CMServerMessageSubtypescamment;
  object->_camment_camment = camment;
  return object;
}

+ (instancetype)invitationWithInvitation:(CMInvitation *)invitation
{
  CMServerMessage *object = [[CMServerMessage alloc] init];
  object->_subtype = _CMServerMessageSubtypesinvitation;
  object->_invitation_invitation = invitation;
  return object;
}

+ (instancetype)membershipAcceptedWithMembershipAcceptedMessage:(CMMembershipAcceptedMessage *)membershipAcceptedMessage
{
  CMServerMessage *object = [[CMServerMessage alloc] init];
  object->_subtype = _CMServerMessageSubtypesmembershipAccepted;
  object->_membershipAccepted_membershipAcceptedMessage = membershipAcceptedMessage;
  return object;
}

+ (instancetype)membershipRequestWithMembershipRequestMessage:(CMMembershipRequestMessage *)membershipRequestMessage
{
  CMServerMessage *object = [[CMServerMessage alloc] init];
  object->_subtype = _CMServerMessageSubtypesmembershipRequest;
  object->_membershipRequest_membershipRequestMessage = membershipRequestMessage;
  return object;
}

+ (instancetype)userJoinedWithUserJoinedMessage:(CMUserJoinedMessage *)userJoinedMessage
{
  CMServerMessage *object = [[CMServerMessage alloc] init];
  object->_subtype = _CMServerMessageSubtypesuserJoined;
  object->_userJoined_userJoinedMessage = userJoinedMessage;
  return object;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  switch (_subtype) {
    case _CMServerMessageSubtypesinvitation: {
      return [NSString stringWithFormat:@"%@ - invitation \n\t invitation: %@; \n", [super description], _invitation_invitation];
      break;
    }
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
    case _CMServerMessageSubtypesmembershipRequest: {
      return [NSString stringWithFormat:@"%@ - membershipRequest \n\t membershipRequestMessage: %@; \n", [super description], _membershipRequest_membershipRequestMessage];
      break;
    }
    case _CMServerMessageSubtypesmembershipAccepted: {
      return [NSString stringWithFormat:@"%@ - membershipAccepted \n\t membershipAcceptedMessage: %@; \n", [super description], _membershipAccepted_membershipAcceptedMessage];
      break;
    }
  }
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {_subtype, [_invitation_invitation hash], [_camment_camment hash], [_userJoined_userJoinedMessage hash], [_cammentDeleted_cammentDeletedMessage hash], [_membershipRequest_membershipRequestMessage hash], [_membershipAccepted_membershipAcceptedMessage hash]};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 7; ++ii) {
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
    (_invitation_invitation == object->_invitation_invitation ? YES : [_invitation_invitation isEqual:object->_invitation_invitation]) &&
    (_camment_camment == object->_camment_camment ? YES : [_camment_camment isEqual:object->_camment_camment]) &&
    (_userJoined_userJoinedMessage == object->_userJoined_userJoinedMessage ? YES : [_userJoined_userJoinedMessage isEqual:object->_userJoined_userJoinedMessage]) &&
    (_cammentDeleted_cammentDeletedMessage == object->_cammentDeleted_cammentDeletedMessage ? YES : [_cammentDeleted_cammentDeletedMessage isEqual:object->_cammentDeleted_cammentDeletedMessage]) &&
    (_membershipRequest_membershipRequestMessage == object->_membershipRequest_membershipRequestMessage ? YES : [_membershipRequest_membershipRequestMessage isEqual:object->_membershipRequest_membershipRequestMessage]) &&
    (_membershipAccepted_membershipAcceptedMessage == object->_membershipAccepted_membershipAcceptedMessage ? YES : [_membershipAccepted_membershipAcceptedMessage isEqual:object->_membershipAccepted_membershipAcceptedMessage]);
}

- (void)matchInvitation:(CMServerMessageInvitationMatchHandler)invitationMatchHandler camment:(CMServerMessageCammentMatchHandler)cammentMatchHandler userJoined:(CMServerMessageUserJoinedMatchHandler)userJoinedMatchHandler cammentDeleted:(CMServerMessageCammentDeletedMatchHandler)cammentDeletedMatchHandler membershipRequest:(CMServerMessageMembershipRequestMatchHandler)membershipRequestMatchHandler membershipAccepted:(CMServerMessageMembershipAcceptedMatchHandler)membershipAcceptedMatchHandler
{
  switch (_subtype) {
    case _CMServerMessageSubtypesinvitation: {
      invitationMatchHandler(_invitation_invitation);
      break;
    }
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
    case _CMServerMessageSubtypesmembershipRequest: {
      membershipRequestMatchHandler(_membershipRequest_membershipRequestMessage);
      break;
    }
    case _CMServerMessageSubtypesmembershipAccepted: {
      membershipAcceptedMatchHandler(_membershipAccepted_membershipAcceptedMessage);
      break;
    }
  }
}

@end

