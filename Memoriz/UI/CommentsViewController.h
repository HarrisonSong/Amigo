//
//  CommentsViewController.h
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelinePostController.h"
#import "ComposeViewDelegate.h"

/**
 *
 * This is the comments viewcontroller that comments for a particular post.
 *
 */
@interface CommentsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id<ComposeViewDelegate> delegate;

// This must be set to load the comments
@property (strong, nonatomic) PostModel *postModel;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UITableView *commentTable;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)postComment:(id)sender;

@property (strong, nonatomic) IBOutlet UIToolbar *bottomToolBar;
@property (strong, nonatomic) IBOutlet UITextField *commentBox;




@end
