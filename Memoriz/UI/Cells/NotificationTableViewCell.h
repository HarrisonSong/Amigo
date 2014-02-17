//
//  NotificationTableViewCell.h
//  Amigo
//
//  Created by Nur Iman Izam on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *notificationLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (strong, nonatomic) IBOutlet UIImageView *uploadedImageView;

- (void)setStyling;

@end
