//
//  FacebookPhotoCell.m
//  Amigo
//
//  Created by Nur Iman Izam Othman on 23/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FacebookPhotoCell.h"

@implementation FacebookPhotoCell

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
    [self.timeAgoLabel setFont:[UIFont fontWithName:OPENSANS_REGULAR size:11.0f]];
    
    if (self.mainImageView.layer.cornerRadius < 5.0) {
        [self.mainImageView.layer setCornerRadius:5.0f];
        [self.mainImageView.layer setMasksToBounds:YES];
    }
}

@end
