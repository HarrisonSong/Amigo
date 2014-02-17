//
//  FriendRequestTableViewCell.h
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol FriendRequestTableViewCellDelgate <NSObject>

- (void)requestCell: (id)cell didPressAcceptAtIndexPath:(NSIndexPath*)indexPath;
- (void)requestCell: (id)cell didPressRejectAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface FriendRequestTableViewCell : UITableViewCell

@property (weak, nonatomic) id<FriendRequestTableViewCellDelgate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
@property (strong, nonatomic) IBOutlet UIButton *rejectButton;

- (void)setStyling;

- (IBAction)acceptButtonPressed:(id)sender;
- (IBAction)rejectButtonPressed:(id)sender;

@end
