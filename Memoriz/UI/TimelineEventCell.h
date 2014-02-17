//
//  TimelineEventCell.h
//  Amigo
//
//  Created by Zenan on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol TimelineEventCellDelegate <NSObject>

- (void)eventCell: (id)cell didPressGoing:(NSIndexPath*)indexPath;

@end

@interface TimelineEventCell : UITableViewCell

@property (weak, nonatomic) id<TimelineEventCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *eventName;
@property (strong, nonatomic) IBOutlet UILabel *eventTime;
@property (strong, nonatomic) IBOutlet UILabel *eventLocation;
@property (strong, nonatomic) IBOutlet UILabel *postTime;
@property (strong, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (strong, nonatomic) IBOutlet UIView *commentsView;
@property (strong, nonatomic) IBOutlet UIButton *goingButton;
@property (strong, nonatomic) IBOutlet UILabel *decisionLabel;

- (IBAction)goingButtonPressed:(id)sender;

- (void)setStyling;
- (void)hideButtons:(BOOL)hide;



@end
