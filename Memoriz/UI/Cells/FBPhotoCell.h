//
//  FBPhotoCell.h
//  Amigo
//
//  Created by Nur Iman Izam Othman on 24/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBPhotoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;

- (void)setStyling;

@end
