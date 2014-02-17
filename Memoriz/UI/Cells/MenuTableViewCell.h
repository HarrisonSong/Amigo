//
//  MenuTableViewCell.h
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainIcon;

- (void)setStyling;

@end
