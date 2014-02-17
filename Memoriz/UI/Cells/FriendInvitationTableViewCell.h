//
//  FriendInvitationTableViewCell.h
//  Amigo
//
//  Created by Nur Iman Izam Othman on 23/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol FriendInvitationTableViewCellDelgate <NSObject>

- (void)invitationCell: (id)cell didPressCancelAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface FriendInvitationTableViewCell : UITableViewCell

@property (weak, nonatomic) id<FriendInvitationTableViewCellDelgate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

- (void)setStyling;

- (IBAction)cancelButtonPressed:(id)sender;

@end
