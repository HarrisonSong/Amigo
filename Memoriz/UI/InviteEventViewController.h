//
//  InviteEventViewController.h
//  Amigo
//
//  Created by Zenan on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserController.h"
#import "ComposeViewDelegate.h"

/**
 *
 * This is the event invite compose viewcontroller.
 *
 */
@interface InviteEventViewController : UIViewController <UIScrollViewDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<ComposeViewDelegate> delegate;

@property (strong, nonatomic) UserModel *friendModel;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)cancelButtonPressed:(id)sender;

@end
