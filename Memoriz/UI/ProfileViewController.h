//
//  ProfileViewController.h
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+SliderView.h"
#import "UserController.h"
#import "UIImageView+AFNetworking.h"
#import "UserModel.h"

/**
 *
 * This is the profile viewcontroller that displays user or friend information.
 *
 */
@interface ProfileViewController : UIViewController

// Set this before displaying to load profile of another user.
// Else it displays current user's profile
@property (strong, nonatomic) UserModel *userModel;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *friendButton;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;

@property (strong, nonatomic) IBOutlet UILabel *amigoCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *postCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *pointsCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (strong, nonatomic) IBOutlet UILabel *bioLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *achievementLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *achievementImageViews;

- (IBAction)menuButtonPressed:(id)sender;
- (IBAction)friendButtonPressed:(id)sender;

@end
