/**
 * This file is generated using the remodel generation script.
 * The name of the input file is ServerMessage.adtValue
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "ServerMessage.h"

typedef NS_ENUM(NSUInteger, _ServerMessageSubtypes) {
  _ServerMessageSubtypesinvitation,
  _ServerMessageSubtypescamment
};

@implementation ServerMessage
{
  _ServerMessageSubtypes _subtype;
  Invitation *_invitation_invitation;
  Camment *_camment_camment;
}

+ (instancetype)cammentWithCamment:(Camment *)camment
{
  ServerMessage *object = [[ServerMessage alloc] init];
  object->_subtype = _ServerMessageSubtypescamment;
  object->_camment_camment = camment;
  return object;
}

+ (instancetype)invitationWithInvitation:(Invitation *)invitation
{
  ServerMessage *object = [[ServerMessage alloc] init];
  object->_subtype = _ServerMessageSubtypesinvitation;
  object->_invitation_invitation = invitation;
  return object;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  switch (_subtype) {
    case _ServerMessageSubtypesinvitation: {
      return [NSString stringWithFormat:@"%@ - invitation \n\t invitation: %@; \n", [super description], _invitation_invitation];
      break;
    }
    case _ServerMessageSubtypescamment: {
      return [NSString stringWithFormat:@"%@ - camment \n\t camment: %@; \n", [super description], _camment_camment];
      break;
    }
  }
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {_subtype, [_invitation_invitation hash], [_camment_camment hash]};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 3; ++ii) {
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

- (BOOL)isEqual:(ServerMessage *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    _subtype == object->_subtype &&
    (_invitation_invitation == object->_invitation_invitation ? YES : [_invitation_invitation isEqual:object->_invitation_invitation]) &&
    (_camment_camment == object->_camment_camment ? YES : [_camment_camment isEqual:object->_camment_camment]);
}

- (void)matchInvitation:(ServerMessageInvitationMatchHandler)invitationMatchHandler camment:(ServerMessageCammentMatchHandler)cammentMatchHandler
{
  switch (_subtype) {
    case _ServerMessageSubtypesinvitation: {
      invitationMatchHandler(_invitation_invitation);
      break;
    }
    case _ServerMessageSubtypescamment: {
      cammentMatchHandler(_camment_camment);
      break;
    }
  }
}

@end

