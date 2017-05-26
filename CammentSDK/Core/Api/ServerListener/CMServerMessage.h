//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CMServerMessage: NSObject

@property (nonatomic, strong) NSData *rawMessage;
@property (nonatomic, strong) NSDictionary *json;

@end