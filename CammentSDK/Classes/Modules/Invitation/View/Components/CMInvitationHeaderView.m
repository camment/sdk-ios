//
// Created by Alexander Fedosov on 08.08.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <CammentSDK/CammentSDK.h>
#import "CMInvitationHeaderView.h"


@interface CMInvitationHeaderView ()
@property(nonatomic) CMInvitationListSection section;
@property(nonatomic, strong) UILabel *sectionLabel;
@end

@implementation CMInvitationHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    return [self init];
}

- (instancetype)init {
    self = [super initWithReuseIdentifier:NSStringFromClass([self class])];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        self.sectionLabel = [[UILabel alloc] init];
        self.sectionLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_sectionLabel];
        
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        self.sectionLabel.text = [aDecoder valueForKey:@"sectionLabelText"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder setValue:self.sectionLabel.text forKey:@"sectionLabelText"];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.sectionLabel.frame = CGRectInset(self.bounds, 20.0f, .0f);
}

- (void)configure:(CMInvitationListSection)section {
    self.section = section;
    switch (section) {
        case CMInvitationListSectionOnline:
            self.sectionLabel.text = CMLocalized(@"user_status.online");
            break;
        case CMInvitationListSectionBusy:
            self.sectionLabel.text = CMLocalized(@"user_status.busy");
            break;
        case CMInvitationListSectionOffline:
            self.sectionLabel.text = CMLocalized(@"user_status.offline");
            break;
        default:
            break;
    }
}

@end
