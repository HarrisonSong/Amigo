//
//  AddPromiseViewController.h
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewDelegate.h"
#import "UserController.h"
#import "UIPlaceHolderTextView.h"
#import "EnableKeyboardHide.h"

/**
 *
 * This is the promise compose viewcontroller.
 *
 */
@interface AddPromiseViewController : UIViewControllerKeyboardHide

@property (weak, nonatomic) id<ComposeViewDelegate> delegate;

@property (strong, nonatomic) UserModel *friendModel;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *postPromiseButton;

@property (strong, nonatomic) IBOutlet UIImageView *userProfilePic;
@property (strong, nonatomic) IBOutlet UIImageView *friendProfilePic;

@property (strong, nonatomic) IBOutlet UIButton *selectDateBtn;
@property (strong, nonatomic) IBOutlet UIDatePicker *promiseDeadlineDate;
@property (strong, nonatomic) IBOutlet UIPlaceHolderTextView *promiseTextView;

- (IBAction)cancelBtn:(id)sender;
- (IBAction)postPromiseBtn:(id)sender;

- (IBAction)selectDateBtn:(id)sender;
- (IBAction)datePickerDidChangeValue:(id)sender;

@end
