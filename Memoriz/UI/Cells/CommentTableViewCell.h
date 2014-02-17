//
//  CommentTableViewCell.h
//  Memoriz
//
//  Created by Zenan on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *commentContent;
@property (strong, nonatomic) IBOutlet UILabel *commentTime;

- (void)setStyling;

@end
