//
//  AddPromiseViewController.m
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AddPromiseViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "TimelinePostController.h"
#import "UserController.h"
#import "UIImageView+AFNetworking.h"

@interface AddPromiseViewController ()

@end

@implementation AddPromiseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setStyling];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.promiseTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUserProfilePic:nil];
    [self setFriendProfilePic:nil];
    [self setSelectDateBtn:nil];
    [self setPromiseDeadlineDate:nil];
    [self setBackButton:nil];
    [self setPostPromiseButton:nil];
    [self setPromiseTextView:nil];
    [super viewDidUnload];
}

- (IBAction)cancelBtn:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)selectDateBtn:(id)sender {
    [self.promiseTextView resignFirstResponder];
}

- (IBAction)postPromiseBtn:(id)sender {
    TimelinePostController *controller = [TimelinePostController sharedInstance];
    PromiseModel *promise = [[PromiseModel alloc] init];
    promise.postType = kPromisePost;
    promise.promiseContent = self.promiseTextView.text;
    promise.promiseDeadline = self.promiseDeadlineDate.date;
    
    [SVProgressHUD showWithStatus:@"Posting Promise..." maskType:SVProgressHUDMaskTypeGradient];
    [controller postPromise:promise ToFriend:self.friendModel complete:^(BOOL success) {
        
        if (success) {
            [self dismissModalViewControllerAnimated:YES];
            [self.delegate composeViewController:self didCompose:promise];
            [SVProgressHUD showSuccessWithStatus:@"Promise Posted!"];
        
        } else {
            [SVProgressHUD showErrorWithStatus:@"Failed to post promise. Try again"];
        }
    }];
}

- (IBAction)datePickerDidChangeValue:(id)sender {
    [self updateDateButton];
}

#pragma mark - Helper Methods

- (void)setStyling {
    [self.backButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.postPromiseButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    NSURL *profileUrl = [Constants facebookProfileImageURLWithId:[[[UserController sharedInstance] fetchCurrentUser] objectForKey:@"facebookId"] andCGSize:CGSizeMake(80, 80)];
    [self.userProfilePic setImageWithURL:profileUrl placeholderImage:[UIImage imageNamed:@"profile-default"]];
    
    [self.userProfilePic.layer setCornerRadius:5.0f];
    [self.userProfilePic.layer setMasksToBounds:YES];
    
    if (self.friendModel) {
        
        NSURL *profileUrl = [Constants facebookProfileImageURLWithId:[self.friendModel objectForKey:@"facebookId"] andCGSize:CGSizeMake(80, 80)];
        [self.friendProfilePic setImageWithURL:profileUrl placeholderImage:[UIImage imageNamed:@"profile-default"]];
        
        [self.friendProfilePic.layer setCornerRadius:5.0f];
        [self.friendProfilePic.layer setMasksToBounds:YES];
    }
    
    [self.promiseTextView setFont:[UIFont fontWithName:OPENSANS_REGULAR size:14.0f]];
    [self.promiseTextView setBackgroundColor:[UIColor whiteColor]];
    [self.promiseTextView setPlaceholder:@"I promise to ..."];
    
    [self updateDateButton];
}

- (void)updateDateButton {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.selectDateBtn setTitle:[dateFormatter stringFromDate:self.promiseDeadlineDate.date] forState:UIControlStateNormal];
}

@end
