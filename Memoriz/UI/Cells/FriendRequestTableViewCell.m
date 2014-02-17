//
//  FriendRequestTableViewCell.m
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FriendRequestTableViewCell.h"

@implementation FriendRequestTableViewCell

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
    
    [self.acceptButton.titleLabel setFont:[UIFont fontWithName:OPENSANS_SEMIBOLD size:15.0f]];
    [self.rejectButton.titleLabel setFont:[UIFont fontWithName:OPENSANS_SEMIBOLD size:15.0f]];
}

- (IBAction)acceptButtonPressed:(id)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(requestCell:didPressAcceptAtIndexPath:)]) {
            [self.delegate requestCell:self didPressAcceptAtIndexPath:self.indexPath];
        }
    }
}

- (IBAction)rejectButtonPressed:(id)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(requestCell:didPressRejectAtIndexPath:)]) {
            [self.delegate requestCell:self didPressRejectAtIndexPath:self.indexPath];
        }
    }
}
@end
