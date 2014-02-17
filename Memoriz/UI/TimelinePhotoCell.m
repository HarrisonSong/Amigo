//
//  TimelinePhotoCell.m
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TimelinePhotoCell.h"

@implementation TimelinePhotoCell

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
    [self.createAt setFont:[UIFont fontWithName:OPENSANS_REGULAR size:11.0f]];
    [self.commentCountLabel setFont:[UIFont fontWithName:OPENSANS_SEMIBOLD size:15.0f]];
    
    [self.userImageView setImage:[UIImage imageNamed:@"profile-default"]];
    
    if (self.userImageView.layer.cornerRadius < 5.0) {
        [self.userImageView.layer setCornerRadius:5.0f];
        [self.userImageView.layer setMasksToBounds:YES];
        
        [self.photo.layer setCornerRadius:5.0f];
        [self.photo.layer setMasksToBounds:YES];
        [self.photo setClipsToBounds:YES];
        
        [self.commentsView.layer setCornerRadius:5.0f];
        [self.commentsView.layer setMasksToBounds:YES];
    }

}

@end
