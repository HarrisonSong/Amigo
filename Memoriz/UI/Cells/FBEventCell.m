//
//  FBEventCell.m
//  Amigo
//
//  Created by Zenan on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FBEventCell.h"

@implementation FBEventCell

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
    [self.eventName setFont:[UIFont fontWithName:OPENSANS_BOLD size:16.0f]];
    [self.eventDesc setFont:[UIFont fontWithName:OPENSANS_SEMIBOLD size:14.0f]];
    [self.eventTime setFont:[UIFont fontWithName:OPENSANS_REGULAR size:12.0f]];
    [self.eventLocation setFont:[UIFont fontWithName:OPENSANS_REGULAR size:12.0f]];
}

@end
