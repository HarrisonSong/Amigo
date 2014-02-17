//
//  FacebookPhotoCell.h
//  Amigo
//
//  Created by Nur Iman Izam Othman on 23/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface FacebookPhotoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeAgoLabel;

- (void)setStyling;
@end
