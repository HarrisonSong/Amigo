//
//  FriendInvitationTableViewCell.m
//  Amigo
//
//  Created by Nur Iman Izam Othman on 23/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FriendInvitationTableViewCell.h"

@implementation FriendInvitationTableViewCell

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
    if (self.profileImageView.layer.cornerRadius < 38.0f) {
        [self.profileImageView.layer setCornerRadius:38.0f];
        [self.profileImageView.layer setMasksToBounds:YES];
    }
    
    [self.cancelButton.titleLabel setFont:[UIFont fontWithName:OPENSANS_SEMIBOLD size:15.0f]];
}

- (IBAction)cancelButtonPressed:(id)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(requestCell:didPressAcceptAtIndexPath:)]) {
            [self.delegate invitationCell:self didPressCancelAtIndexPath:self.indexPath];
        }
    }
}


@end
