//
//  ComposeMessageViewController.m
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "EmoticonController.h"
#import "ComposeMessageViewController.h"
#import "MessageModel.h"
#import "TimelinePostController.h"
#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface ComposeMessageViewController ()

@property (strong, nonatomic) NSArray *friendsArray;
@property (strong, nonatomic) NSMutableArray *friendsActive;

@end

@implementation ComposeMessageViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setStyling];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setDefaultFriends];
    [self setDefaultEmotionStatus];

    sendToFacebook = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.postMessage becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPostMessage:nil];
    [self setEmotionStatus:nil];
    [self setBackButton:nil];
    [self setSendButton:nil];
    [self setBottomBar:nil];
    [self setComposerImageView:nil];
    [self setFriendImageViews:nil];
    [self setFriendButtons:nil];
    [self setFacebookButton:nil];
    [super viewDidUnload];
}

#pragma mark - Keyboard Handler 

- (void) keyboardWillShow: (NSNotification*)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    //Get Keyboard height
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    keyBoardHeight = self.view.bounds.size.height - keyboardTop;
    NSLog(@"%f",keyBoardHeight);
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect newFrame = self.view.frame;
        newFrame.size.height = newFrame.size.height - keyBoardHeight;
        [self.view setFrame:newFrame];
    }];
}

- (void) keyboardWillHide: (NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.    
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect newFrame = self.view.frame;
        newFrame.size.height = self.view.bounds.size.height + keyBoardHeight;
        [self.view setFrame:newFrame];
    }];
}

#pragma mark - Button Methods

- (IBAction)facebookButtonPressed:(id)sender {
    if (sendToFacebook) {
        [self.facebookButton setAlpha:0.3];
        sendToFacebook = NO;
    } else {
        [self.facebookButton setAlpha:1.0];
        sendToFacebook = YES;
    }
}

- (IBAction)friendButtonPressed:(UIButton*)button {
    if ([[self.friendsActive objectAtIndex:button.tag] boolValue]) {
        [self setFriendAtIndex:button.tag active:NO];
    } else {
        [self setFriendAtIndex:button.tag active:YES];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)postMessageButtonPressed:(id)sender {
    
    // Check if message is empty
    if ([self.postMessage.text length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"Please enter your message."];
        return;
    }
    
    // Create array of friends to post to
    NSMutableArray *postFriends = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.friendsArray.count;i++) {
        if ([[self.friendsActive objectAtIndex:i] boolValue]) {
            [postFriends addObject:[self.friendsArray objectAtIndex:i]];
        }
    }
    
    // Check if no friends selected
    if ([postFriends count] == 0) {
        [SVProgressHUD showErrorWithStatus:@"Choose at least one friend below."];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Posting Message..." maskType:SVProgressHUDMaskTypeGradient];
    
    // Loop through friends to post message
    for (UserModel *friend in postFriends) {
        // Create Message
        MessageModel *messageModel = [[MessageModel alloc] init];
        messageModel.postType = kMessagePost;
        messageModel.emotionNumber = self.currentEmotion;
        messageModel.message = self.postMessage.text;
        static bool proceed = true;
        [[TimelinePostController sharedInstance] postMessage:messageModel ToFriend:friend complete:^(BOOL success) {
            if (success) {
                [SVProgressHUD showSuccessWithStatus:@"Message Posted!"];
                if(proceed){
                    [self.delegate composeViewController:self didCompose:messageModel];
                    proceed = false;
                }
                [self dismissModalViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:@"Message send failed. Try again"];
            }
        }];
    }
    
    if (sendToFacebook) {
        [[UserController sharedInstance] postToFacebookWall:self.postMessage.text withCompletionHandler:^(BOOL successs) {
        }];
    }
}

#pragma mark - Helper Methods

- (void)setStyling {
    
    // Style Buttons
    [self.backButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.sendButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // Setup Composer
    NSURL *profileUrl = [Constants facebookProfileImageURLWithId:[[[UserController sharedInstance] fetchCurrentUser] objectForKey:@"facebookId"] andCGSize:CGSizeMake(80, 80)];
    [self.composerImageView setImageWithURL:profileUrl placeholderImage:[UIImage imageNamed:@"profile-default"]];
    
    [self.composerImageView.layer setCornerRadius:5.0f];
    [self.composerImageView.layer setMasksToBounds:YES];
    
    // Setup Bottom Bar
    self.friendImageViews = [self.friendImageViews sortedArrayUsingComparator:^NSComparisonResult(id view1, id view2) {
        if ([view1 frame].origin.x < [view2 frame].origin.x) return NSOrderedAscending;
        else if ([view1 frame].origin.x > [view2 frame].origin.x) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
    
    self.friendButtons = [self.friendButtons sortedArrayUsingComparator:^NSComparisonResult(id view1, id view2) {
        if ([view1 frame].origin.x < [view2 frame].origin.x) return NSOrderedAscending;
        else if ([view1 frame].origin.x > [view2 frame].origin.x) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
    
    [self.postMessage setFont:[UIFont fontWithName:OPENSANS_REGULAR size:14.0f]];
    [self.postMessage setBackgroundColor:[UIColor whiteColor]];
    [self.postMessage setPlaceholder:@"Share something on your mind..."];
}

- (void)setDefaultFriends {
    
    // Set Active States
    self.friendsActive = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO], nil];
    
    [FriendsController getFriendsListWithCompletionHandler:^(NSArray *friendsArray, NSError *error) {
        
        self.friendsArray = friendsArray;
        
        NSInteger friendIndex = 0;
        for (UserModel *friendModel in friendsArray) {
            NSURL *profileUrl = [Constants facebookProfileImageURLWithId:[friendModel objectForKey:@"facebookId"] andCGSize:CGSizeMake(100, 100)];
            UIImageView *friendImageView =  (UIImageView*)[self.friendImageViews objectAtIndex:friendIndex];
            [friendImageView setImageWithURL:profileUrl placeholderImage:[UIImage imageNamed:@"profile-default"]];
            
            [friendImageView.layer setCornerRadius:5.0f];
            [friendImageView.layer setMasksToBounds:YES];
            
            [[self.friendButtons objectAtIndex:friendIndex] setEnabled:YES];
            
            if (self.defaultActiveFriends) {
                for (UserModel *model in self.defaultActiveFriends) {
                    if ([friendModel.objectId isEqualToString:model.objectId]) {
                        [friendImageView setAlpha:1.0];
                        [self.friendsActive replaceObjectAtIndex:friendIndex withObject:[NSNumber numberWithBool:YES]];
                    }
                }
            }
            
            friendIndex++;
        }
    }];
}

- (void)setFriendAtIndex:(NSInteger)index active:(BOOL)active {
    
    if (active) {
        [[self.friendImageViews objectAtIndex:index] setAlpha:1.0];
    } else {
        [[self.friendImageViews objectAtIndex:index] setAlpha:0.3];
    }
    
    [self.friendsActive replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:active]];
}

#pragma mark - Emotions Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == self.emotionStatus) {
        NSLog(@"show popover view");
        [self.view endEditing:YES];
        CGPoint point = [touch locationInView:self.view];
        EmoticonPopoverView *popoverView = [[EmoticonPopoverView alloc] initWithFrame:CGRectMake(0, 0, 288, 144)];
        popoverView.delegate = self;
        self.emotionPopoverView = [PopoverView showPopoverAtPoint:point inView:self.view withContentView:popoverView delegate:nil];
    }
}

- (void)setDefaultEmotionStatus
{
    self.currentEmotion = 1;
    UIImage *emotion = [UIImage imageNamed:@"1.png"];
    [self.emotionStatus setImage:emotion];
}

- (void)setCurrentEmotionStatus:(NSInteger)emotionNumber
{
    UIImage *emotion = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", emotionNumber]];
    [self.emotionStatus setImage:emotion];
}

#pragma mark - PopoverViewDelegate Methods

- (void)emoticonSelected:(NSInteger)emoticonNumber
{
    NSLog(@"emotion selected");
    [self setCurrentEmotionStatus:emoticonNumber];
    [self.emotionPopoverView dismiss];
    self.currentEmotion = emoticonNumber;
}



@end
