//
//  FriendsTableViewCell.m
//  Memoriz
//
//  Created by Nur Iman Izam on 8/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FriendsTableViewCell.h"

@implementation FriendsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStyling {
    [self.nameLabel setFont:[UIFont fontWithName:OPENSANS_SEMIBOLD size:18.0f]];
    [self.latestLabel setFont:[UIFont fontWithName:OPENSANS_REGULAR size:16.0f]];
    if (self.profileImageView.layer.cornerRadius < 38.0f) {
        [self.profileImageView.layer setCornerRadius:38.0f];
        [self.profileImageView.layer setMasksToBounds:YES];
    }
}

@end
