//
// Created by Alexander Fedosov on 06.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMServerMessage;


@interface CMServerMessageParser : NSObject

@property(nonatomic, strong) NSDictionary *messageDictionary;

- (instancetype)initWithMessageDictionary:(NSDictionary *)messageDictionary;
- (CMServerMessage *)parseMessage;

@end