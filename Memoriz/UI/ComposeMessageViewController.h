//
//  ComposeMessageViewController.h
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverView.h"
#import "EmoticonPopoverView.h"
#import "ComposeViewDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "UIPlaceHolderTextView.h"
#import "FriendsController.h"

/**
 *
 * This is the message compose viewcontroller.
 *
 */
@interface ComposeMessageViewController : UIViewController <EmoticonPopoverDelegate> {
    CGFloat keyBoardHeight;
    BOOL sendToFacebook;
}

@property (weak, nonatomic) id<ComposeViewDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *defaultActiveFriends;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;

@property (strong, nonatomic) IBOutlet UIImageView *composerImageView;
@property (strong, nonatomic) IBOutlet UIImageView *emotionStatus;
@property (strong, nonatomic) IBOutlet UIPlaceHolderTextView *postMessage;

@property (strong, nonatomic) IBOutlet UIView *bottomBar;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *friendImageViews;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *friendButtons;

- (IBAction)facebookButtonPressed:(id)sender;
- (IBAction)friendButtonPressed:(UIButton*)button;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)postMessageButtonPressed:(id)sender;

// Emotions
@property (strong, nonatomic) PopoverView *emotionPopoverView;
@property (nonatomic, assign) NSInteger currentEmotion;

@end
