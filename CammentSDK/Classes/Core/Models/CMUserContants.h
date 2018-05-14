//
// Created by Alexander Fedosov on 04.02.2018.
//

#import <Foundation/Foundation.h>


FOUNDATION_EXPORT const struct CMUserBlockStatus {
    __unsafe_unretained NSString *Active;
    __unsafe_unretained NSString *Blocked;
} CMUserBlockStatus;

FOUNDATION_EXPORT const struct CMUserOnlineStatus {
    __unsafe_unretained NSString *Online;
    __unsafe_unretained NSString *Offline;
    __unsafe_unretained NSString *Broadcasting;
} CMUserOnlineStatus;