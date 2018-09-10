//
// Created by Alexander Fedosov on 03.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMShowMetadata.h"


@implementation CMShowMetadata {

}

- (NSString *)invitationText {
    return _invitationText ?: CMLocalized(@"invitations.text");
}

@end