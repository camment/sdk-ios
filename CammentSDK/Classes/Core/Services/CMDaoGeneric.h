//
// Created by Alexander Fedosov on 08/08/2018.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>

@class YapDatabase;

@interface CMDaoGeneric <__covariant ObjectType:id<NSCoding>> : NSObject

@property(nonatomic, readonly) YapDatabase *database;

- (instancetype)initWithDatabase:(YapDatabase *)database;
- (BFTask<ObjectType> *)entityWithId:(NSString *)uuid;
- (BFTask<ObjectType> *)saveEntity:(ObjectType)entity;

@end