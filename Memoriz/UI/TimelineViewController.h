//
//  TimelineViewController.h
//  Memoriz
//
//  Created by Nur Iman Izam on 27/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+SliderView.h"
#import "ServerController.h"
#import "UserModel.h"
#import "ComposeViewDelegate.h"
#import "TimelinePromiseCell.h"
#import "TimelineEventCell.h"

extern NSString *const TIMELINE_PHOTO_NIB;
extern NSString *const TIMELINE_MESSAGE_NIB;
extern NSString *const TIMELINE_PROMISE_NIB;
extern NSString *const TIMELINE_EVENT_NIB;
extern NSString *const TIMELINE_FACEBOOK_PHOTO_NIB;

typedef enum {
    kBottomBarStateShown,
    kBottomBarStateHidden
} kBottomBarState;

/**
 *
 * This is the timeline viewcontroller that displays the private timelines between user and his friend.
 *
 */
@interface TimelineViewController : UIViewController <UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UIPopoverControllerDelegate, ComposeViewDelegate, TimelinePromiseCellDelegate,TimelineEventCellDelegate>

{
    kBottomBarState bottomBarState;
}

// Must set this to load the timeline
@property (strong, nonatomic) UserModel *friendModel;

// Table Header
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UIImageView *friendCoverImageView;
@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) IBOutlet UIButton *profileButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *friendButton;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *bottomBarView;

- (IBAction)menuButtonPressed:(id)sender;
- (IBAction)friendButtonPressed:(id)sender;
- (IBAction)profileButtonPressed:(id)sender;

- (IBAction)plusButtonPressed:(id)sender;
- (IBAction)composeButtonPressed:(id)sender;
- (IBAction)cameraButtonPressed:(id)sender;
- (IBAction)newPromiseButtonPressed:(id)sender;
- (IBAction)eventButtonPressed:(id)sender;

@end
