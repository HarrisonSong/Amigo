//
//  MenuTableViewCell.m
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

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
    [self.mainLabel setFont:[UIFont fontWithName:OPENSANS_SEMIBOLD size:16.0f]];
}

@end
