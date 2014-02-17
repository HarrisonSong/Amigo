//
//  LoginViewController.h
//  Memoriz
//
//  Created by Nur Iman Izam on 27/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UserController.h"
#import "SVProgressHUD.h"

/*
 
 This class is the view controller for user to login.
 
 */
@interface LoginViewController : UIViewController <FacebookLoginDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;

- (IBAction)loginButtonPressed:(id)sender;

@end
