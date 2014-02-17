//
//  LoginViewController.m
//  Memoriz
//
//  Created by Nur Iman Izam on 27/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UserController sharedInstance].loginDelegate = self;
    [self setStyling];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}

#pragma mark - Button Actions

- (IBAction)loginButtonPressed:(id)sender {
    [[UserController sharedInstance] loginFaceBookUser];
}

#pragma mark - FacebookLoginDelegate Methods

-(void) facebookLoginSuccessWithNewUser {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    [self facebookLoginSuccessWithExistingUser];
}

-(void) facebookLoginSuccessWithExistingUser {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    [SVProgressHUD showSuccessWithStatus:@"Successfully logged in!"];
    
    if (IS_IPAD()) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        UIViewController *splitView = [self.storyboard instantiateViewControllerWithIdentifier:@"SplitView"];
        [appDelegate.window setRootViewController:splitView];
    } else {
        [self performSegueWithIdentifier:@"kLoadSliderView" sender:self];
    }
}

- (void) facebookLoginFailedWithError:(NSError*)error {
    DDLogVerbose(@"%@: %@: %@", THIS_FILE, THIS_METHOD,[error localizedDescription]);
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"Login Failed"];
    }
}

#pragma mark - Helper Functions

- (void)setStyling {
    self.textView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    self.textView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.textView.layer.shadowOpacity = 1.0f;
    self.textView.layer.shadowRadius = 1.0f;
    
    if (IS_IPAD()) {
        [self.textView setFont:[UIFont fontWithName:OPENSANS_REGULAR size:22.0f]];
    } else {
        [self.textView setFont:[UIFont fontWithName:OPENSANS_REGULAR size:15.0f]];
    }
}

@end
