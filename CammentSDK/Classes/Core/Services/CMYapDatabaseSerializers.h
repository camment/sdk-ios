//
// Created by Alexander Fedosov on 08/08/2018.
//

#import <Foundation/Foundation.h>
#import <YapDatabase/YapDatabase.h>


@interface CMYapDatabaseSerializers : NSObject
+ (YapDatabaseSerializer)defaultSerializer;

+ (YapDatabaseDeserializer)defaultDeserializer;
@end
