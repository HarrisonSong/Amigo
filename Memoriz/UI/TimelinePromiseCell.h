//
//  TimelinePromiseCell.h
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PromiseModel.h"   

@protocol TimelinePromiseCellDelegate <NSObject>

- (void)promiseCell: (id)cell didPressAcceptAtIndexPath:(NSIndexPath*)indexPath;
- (void)promiseCell: (id)cell didPressRejectAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface TimelinePromiseCell : UITableViewCell

@property (weak, nonatomic) id<TimelinePromiseCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) IBOutlet UIImageView *profilePic;

@property (strong, nonatomic) IBOutlet UILabel *promiseHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *promiseContent;
@property (strong, nonatomic) IBOutlet UILabel *postedTime;
@property (strong, nonatomic) IBOutlet UILabel *deadlineLabel;

@property (strong, nonatomic) IBOutlet UIView *commentsView;
@property (strong, nonatomic) IBOutlet UILabel *commentsCountLabel;

@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
@property (strong, nonatomic) IBOutlet UIButton *rejectButton;
@property (strong, nonatomic) IBOutlet UILabel *fulfilledLabel;

- (IBAction)acceptButtonPressed:(id)sender;
- (IBAction)rejectButtonPressed:(id)sender;

- (void)setStyling;
- (void)hideButtons:(BOOL)hide;

@end
