//
// Created by Alexander Fedosov on 03.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CMShowMetadata : NSObject

// Show uuid is a unique identifier for your show
@property (nonatomic, copy) NSString *uuid;

// Set a custom text to be shared along with invitation link
// If nil, default text will be used
@property (nonatomic, copy) NSString *invitationText;

@end