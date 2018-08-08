//
// Created by Alexander Fedosov on 08/08/2018.
//

#import "CMYapDatabaseSerializers.h"
#import <YapDatabase/YapDatabase.h>
#import "CMCamment.h"
#import "CMCammentBuilder.h"

@implementation CMYapDatabaseSerializers {

}

+ (YapDatabaseSerializer)defaultSerializer
{
    return ^ NSData* (NSString __unused *collection, NSString __unused *key, id object){
        return [NSKeyedArchiver archivedDataWithRootObject:object];
    };
}

+ (YapDatabaseDeserializer)defaultDeserializer
{
    return ^ id (NSString __unused *collection, NSString __unused *key, NSData *data){

        if (!data || data.length == 0 ) { return nil; }

        id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return object;
    };
}


@end
