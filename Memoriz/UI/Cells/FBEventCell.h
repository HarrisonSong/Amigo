//
//  FBEventCell.h
//  Amigo
//
//  Created by Zenan on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBEventCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *eventName;
@property (strong, nonatomic) IBOutlet UILabel *eventDesc;
@property (strong, nonatomic) IBOutlet UILabel *eventTime;
@property (strong, nonatomic) IBOutlet UILabel *eventLocation;

- (void)setStyling;

@end
