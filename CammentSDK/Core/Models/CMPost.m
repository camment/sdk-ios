/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMPost.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMPost.h"

@implementation CMPost

- (instancetype)initWithPostId:(NSInteger)postId uuid:(NSString *)uuid desc:(NSString *)desc createdAt:(NSString *)createdAt thumbnail:(NSString *)thumbnail camments:(NSArray<CMCamment* > *)camments user:(CMUser *)user liked:(BOOL)liked totalLikes:(NSInteger)totalLikes totalCamments:(NSInteger)totalCamments
{
  if ((self = [super init])) {
    _postId = postId;
    _uuid = [uuid copy];
    _desc = [desc copy];
    _createdAt = [createdAt copy];
    _thumbnail = [thumbnail copy];
    _camments = [camments copy];
    _user = [user copy];
    _liked = liked;
    _totalLikes = totalLikes;
    _totalCamments = totalCamments;
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t postId: %zd; \n\t uuid: %@; \n\t desc: %@; \n\t createdAt: %@; \n\t thumbnail: %@; \n\t camments: %@; \n\t user: %@; \n\t liked: %@; \n\t totalLikes: %zd; \n\t totalCamments: %zd; \n", [super description], _postId, _uuid, _desc, _createdAt, _thumbnail, _camments, _user, _liked ? @"YES" : @"NO", _totalLikes, _totalCamments];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {ABS(_postId), [_uuid hash], [_desc hash], [_createdAt hash], [_thumbnail hash], [_camments hash], [_user hash], (NSUInteger)_liked, ABS(_totalLikes), ABS(_totalCamments)};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 10; ++ii) {
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

- (BOOL)isEqual:(CMPost *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    _postId == object->_postId &&
    _liked == object->_liked &&
    _totalLikes == object->_totalLikes &&
    _totalCamments == object->_totalCamments &&
    (_uuid == object->_uuid ? YES : [_uuid isEqual:object->_uuid]) &&
    (_desc == object->_desc ? YES : [_desc isEqual:object->_desc]) &&
    (_createdAt == object->_createdAt ? YES : [_createdAt isEqual:object->_createdAt]) &&
    (_thumbnail == object->_thumbnail ? YES : [_thumbnail isEqual:object->_thumbnail]) &&
    (_camments == object->_camments ? YES : [_camments isEqual:object->_camments]) &&
    (_user == object->_user ? YES : [_user isEqual:object->_user]);
}

@end

