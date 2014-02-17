//
//  TimelineEventCell.m
//  Amigo
//
//  Created by Zenan on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//


#import "TimelineEventCell.h"

@implementation TimelineEventCell

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
    [self.postTime setFont:[UIFont fontWithName:OPENSANS_REGULAR size:11.0f]];
    [self.eventTime setFont:[UIFont fontWithName:OPENSANS_REGULAR size:13.0f]];
    [self.eventLocation setFont:[UIFont fontWithName:OPENSANS_REGULAR size:13.0f]];
    [self.eventName setFont:[UIFont fontWithName:OPENSANS_SEMIBOLD size:15.0f]];
    
    [self.profilePic setImage:[UIImage imageNamed:@"profile-default"]];
    
    if (self.profilePic.layer.cornerRadius < 5.0) {
        [self.profilePic.layer setCornerRadius:5.0f];
        [self.profilePic.layer setMasksToBounds:YES];
        
        [self.commentsView.layer setCornerRadius:5.0f];
        [self.commentsView.layer setMasksToBounds:YES];
    }
}

- (void)hideButtons:(BOOL)hide {
    [self.goingButton setHidden:hide];
}

- (IBAction)goingButtonPressed:(id)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(eventCell:didPressGoing:)]) {
            [self.delegate eventCell:self didPressGoing:self.indexPath];
        }
    }
}

@end
