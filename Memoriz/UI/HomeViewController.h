//
//  HomeViewController.h
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "FriendsController.h"
#import "PointsController.h"

/**
 *
 * This is the first viewcontroller if user is logged in.
 *
 */
@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *friendButton;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;

- (IBAction)menuButtonPressed:(id)sender;
- (IBAction)friendButtonPressed:(id)sender;

- (IBAction)composeButtonPressed:(id)sender;
- (IBAction)photoButtonPressed:(id)sender;

@end
