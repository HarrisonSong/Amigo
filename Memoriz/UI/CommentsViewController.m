//
//  CommentsViewController.m
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentsController.h"
#import "CommentTableViewCell.h"
#import "NSDate+TimeAgo.h"
#import "UserController.h"
#import "UIImageView+AFNetworking.h"

@interface CommentsViewController ()

@property (nonatomic, strong) NSArray *commentsArray;

@end

@implementation CommentsViewController

#pragma mark - UIViewController Lifecycle

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
    [self addGestures];
    [self loadComments];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadComments];    
}

- (void)viewDidUnload {
    [self setBottomToolBar:nil];
    [self setCommentTable:nil];
    [self setCommentBox:nil];
    [self setBackButton:nil];
    [super viewDidUnload];
}

#pragma mark - Keyboard Handling

- (void)keyboardWillShown:(NSNotification*)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:NO];
}

- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up {
    
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.view.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    keyboardFrame.size.height -= self.navigationController.navigationBar.frame.size.height - self.bottomToolBar.frame.size.height;
    newFrame.size.height -= keyboardFrame.size.height * (up?1:-1);
    self.view.frame = newFrame;
    
    [UIView commitAnimations];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.commentsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentsModel *commentModel = [self.commentsArray objectAtIndex:indexPath.row];
    
    CGSize constraintSize = {232.0f, INFINITY};
    CGSize neededSize = [commentModel.content sizeWithFont:[UIFont fontWithName:OPENSANS_REGULAR size:13.0f] constrainedToSize:constraintSize];
    
    NSLog(@"needed height: %f",neededSize.height);
    return MAX(60.0f, neededSize.height+44.0f);
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentsModel *commentModel = [self.commentsArray objectAtIndex:indexPath.row];
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    [cell setStyling];
    
    [[UserController sharedInstance] fetchFacebookIDForUser:commentModel.commenterUserID WithCompletionHandler:^(NSString *facebookID) {
        if (facebookID) {
            NSString *profileUrlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=80&height=80",facebookID];
            [cell.profileImage setImageWithURL:[NSURL URLWithString:profileUrlString] placeholderImage:[UIImage imageNamed:@"profile-default"]];
        }
    }];
    
    // Set Label Height
    CGSize constraintSize = {232.0f, INFINITY};
    CGSize neededSize = [commentModel.content sizeWithFont:[UIFont fontWithName:OPENSANS_REGULAR size:13.0f] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect newFrame = cell.commentContent.frame;
    newFrame.size.height = MAX(26.0f, neededSize.height);
    [cell.commentContent setFrame: newFrame];
    
    // Set Data
    [cell.commentContent setText:commentModel.content];
    [cell.commentTime setText:[commentModel.createdAt timeAgo]];
    
    return cell;
}

#pragma mark - Button Actions

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)postComment:(id)sender {
    
    if ([self.commentBox.text length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"Please enter a comment."];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Posting Comment.." maskType:SVProgressHUDMaskTypeGradient];
    NSString *comment = self.commentBox.text;
    [CommentsController addComments:self.postModel content:comment withCompletionHandler:^(NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"Comment Posted!"];
            [self.commentBox setText:@""];
            [self.delegate composeViewController:self didCommentForPost:self.postModel];
            [self loadComments];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Error posting comment..."];
            NSLog(@"%@", error);
        }
    }];
}

#pragma mark - Helper Methods

- (void)setStyling {
    [self.backButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (void)addGestures {
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonPressed:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
}

-(void)loadComments{
    [CommentsController getComments:self.postModel.objectId withCompletionHandler:^(NSArray *commentsArray, NSError *error) {
        if (!error) {
            self.commentsArray = commentsArray;
            [self.commentTable reloadData];
        }
    }];
}



@end
