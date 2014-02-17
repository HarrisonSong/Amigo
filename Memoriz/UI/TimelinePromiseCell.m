//
//  TimelinePromiseCell.m
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TimelinePromiseCell.h"

@implementation TimelinePromiseCell

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

- (IBAction)acceptButtonPressed:(id)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(promiseCell:didPressAcceptAtIndexPath:)]) {
            [self.delegate promiseCell:self didPressAcceptAtIndexPath:self.indexPath];
        }
    }
}

- (IBAction)rejectButtonPressed:(id)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(promiseCell:didPressAcceptAtIndexPath:)]) {
            [self.delegate promiseCell:self didPressRejectAtIndexPath:self.indexPath];
        }
    }
}

- (void)setStyling {
    [self.postedTime setFont:[UIFont fontWithName:OPENSANS_REGULAR size:11.0f]];
    [self.deadlineLabel setFont:[UIFont fontWithName:OPENSANS_SEMIBOLD size:13.0f]];
    [self.promiseContent setFont:[UIFont fontWithName:OPENSANS_SEMIBOLD size:13.0f]];
    [self.promiseHeaderLabel setFont:[UIFont fontWithName:OPENSANS_BOLD size:13.0f]];
    [self.commentsCountLabel setFont:[UIFont fontWithName:OPENSANS_SEMIBOLD size:15.0f]];
    
    [self.profilePic setImage:[UIImage imageNamed:@"profile-default"]];
    
    if (self.profilePic.layer.cornerRadius < 5.0) {
        [self.profilePic.layer setCornerRadius:5.0f];
        [self.profilePic.layer setMasksToBounds:YES];
        
        [self.commentsView.layer setCornerRadius:5.0f];
        [self.commentsView.layer setMasksToBounds:YES];
    }
}

- (void)hideButtons:(BOOL)hide {
    [self.acceptButton setHidden:hide];
    [self.rejectButton setHidden:hide];
    [self.fulfilledLabel setHidden:!hide];
}

@end
