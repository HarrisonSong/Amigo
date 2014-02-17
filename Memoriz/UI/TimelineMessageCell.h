//
//  TimelineMessageCell.h
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TimelineMessageCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *postTime;
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UIImageView *emotionStatus;
@property (strong, nonatomic) IBOutlet UIView *commentsView;
@property (strong, nonatomic) IBOutlet UILabel *commentsCountLabel;

- (void)setStyling;

@end
