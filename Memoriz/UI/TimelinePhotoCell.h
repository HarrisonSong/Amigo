//
//  TimelinePhotoCell.h
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

@interface TimelinePhotoCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UILabel *createAt;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (strong, nonatomic) IBOutlet UIView *commentsView;

- (void)setStyling;

@end
