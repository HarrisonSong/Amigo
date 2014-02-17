//
//  CommentTableViewCell.m
//  Memoriz
//
//  Created by Zenan on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

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
    [self.commentTime setFont:[UIFont fontWithName:OPENSANS_REGULAR size:11.0f]];
    [self.commentContent setFont:[UIFont fontWithName:OPENSANS_REGULAR size:13.0f]];
    
    if (self.profileImage.layer.cornerRadius < 38.0f) {
        [self.profileImage.layer setCornerRadius:5.0f];
        [self.profileImage.layer setMasksToBounds:YES];
    }
    
    [self.profileImage setImage:[UIImage imageNamed:@"profile-default"]];
}

@end
