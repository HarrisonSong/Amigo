//
//  NotificationTableViewCell.m
//  Amigo
//
//  Created by Nur Iman Izam on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation NotificationTableViewCell

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
    [self setBackgroundColor:[UIColor colorWithHue:0.39f saturation:0.0f brightness:0.96f alpha:1.0]];
    
    [self.notificationLabel setFont:[UIFont fontWithName:OPENSANS_SEMIBOLD size:15.0f]];
    [self.timeAgoLabel setFont:[UIFont fontWithName:OPENSANS_REGULAR size:11.0f]];
    
    if (self.userProfileImageView.layer.cornerRadius < 38.0f) {
        [self.userProfileImageView.layer setCornerRadius:5.0f];
        [self.userProfileImageView.layer setMasksToBounds:YES];
        [self.uploadedImageView.layer setCornerRadius:5.0f];
        [self.uploadedImageView.layer setMasksToBounds:YES];
    }
}

@end
