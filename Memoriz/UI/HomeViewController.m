//
//  HomeViewController.m
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewController+SliderView.h"
#import "TimelinePostController.h"
#import "NotificationTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+TimeAgo.h"
#import "ComposeMessageViewController.h"
#import "AddPhotoViewController.h"
#import "TimelineViewController.h"
#import "SplitViewController.h"

@interface HomeViewController ()

@property (strong, nonatomic) NSArray *notificationsArray;

@end

@implementation HomeViewController

#pragma mark - UIViewController Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializations
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    if (!IS_IPAD()) {
        [self setupTopViewController];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setStyling];
    
    self.notificationsArray= @[];
    
    [[TimelinePostController sharedInstance] getLatestPostsFromFriendsWithCompletion:^(NSArray *objects, NSError *error) {
        DDLogVerbose(@"%@: %@, LATEST POST: %@",THIS_FILE,THIS_METHOD,objects);
        self.notificationsArray = objects;
        [self.tableView reloadData];
    }];
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMenuButton:nil];
    [self setFriendButton:nil];
    [self setTableView:nil];
    [self setTableHeaderView:nil];
    [super viewDidUnload];
}

#pragma mark - Button Actions

- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)friendButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

- (IBAction)composeButtonPressed:(id)sender {
    ComposeMessageViewController *composeMessageView = [self.storyboard instantiateViewControllerWithIdentifier:@"ComposeMessageView"];
    
    if (IS_IPAD()) {
        composeMessageView.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentModalViewController:composeMessageView animated:YES];
}

- (IBAction)photoButtonPressed:(id)sender {
    AddPhotoViewController *addPhotoView = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPhotoView"];
    
    if (IS_IPAD()) {
        addPhotoView.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentModalViewController:addPhotoView animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.notificationsArray count];
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 24)];
    [headerView setBackgroundColor:[UIColor colorWithRed:0.137254902f green:0.137254902f blue:0.137254902f alpha:0.6f]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 260, 24)];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setTextAlignment:NSTextAlignmentLeft];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setFont:[UIFont fontWithName:OPENSANS_BOLD size:14.0f]];
    [headerView addSubview:headerLabel];
    
    UIImageView *separatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0,23, 320, 1)];
    [separatorView setImage:[UIImage imageNamed:@"separator"]];
    [headerView addSubview:separatorView];
    
    [headerLabel setText:@"Notifications"];

    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NotificationCell";
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setStyling];
    
    PostModel *post = [self.notificationsArray objectAtIndex:indexPath.row];
    cell = [self populateCell:cell withPostData:post];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *userId = [[self.notificationsArray objectAtIndex:indexPath.row] objectForKey:@"creatorUserID"];
    [ServerController  queryUserWithConditions:@{@"objectId": userId} andCachePolicy:NO andCompletionHandler:^(NSArray *results, NSError *error) {
        
        UserModel *user = [results objectAtIndex:0];
        
        UINavigationController *timelineNavigation = [self.storyboard instantiateViewControllerWithIdentifier:@"TimelineView"];
        TimelineViewController *timelineView = [[timelineNavigation viewControllers] objectAtIndex:0];
        timelineView.friendModel = user;
        
        if (IS_IPAD()) {
            SplitViewController *splitView = (SplitViewController*)self.parentViewController.parentViewController;
            NSLog(@"%@",splitView);
            
            NSArray *newVCs = @[[splitView.viewControllers objectAtIndex:0], timelineNavigation];
            splitView.viewControllers = newVCs;
            
        } else {
            [self.navigationController pushViewController:timelineView animated:YES];
        }
    }];

}

#pragma mark - Helper Functions

- (void)setStyling {
    [self.menuButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.friendButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"help_bg"]];
    self.tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.tableHeaderView;
}

- (NotificationTableViewCell*)populateCell:(NotificationTableViewCell*)cell withPostData:(PostModel*)post {
    
    [cell.uploadedImageView setImage:nil];
    
    [[UserController sharedInstance] fetchFacebookIDForUser:post.creatorUserID WithCompletionHandler:^(NSString *facebookID) {
        NSURL *profileUrl = [Constants facebookProfileImageURLWithId:facebookID andCGSize:CGSizeMake(80, 80)];
        [cell.userProfileImageView setImageWithURL:profileUrl placeholderImage:[UIImage imageNamed:@"profile-default"]];
    }];
    
    [cell.timeAgoLabel setText:[post.createdAt timeAgo]];
        
    switch (post.postType) {
            
        case kMessagePost:
            [self populateCell:cell forMessage:(MessageModel*)post];
            break;
            
        case kPhotoPost:
            [self populateCell:cell forPhoto:(PhotoModel*)post];
            break;
            
        case kPromisePost:
            [self populateCell:cell forPromise:(PromiseModel*)post];
            break;
            
        case kGamePost:
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NotificationTableViewCell*)populateCell:(NotificationTableViewCell*)cell forMessage:(MessageModel*)messagePost {
    
    [cell.notificationLabel setText:messagePost.message];
    NSString *emotionFilename;
    
    if (messagePost.emotionNumber == 0) {
        emotionFilename = @"1";
    } else {
        emotionFilename = [NSString stringWithFormat:@"%d",messagePost.emotionNumber];
    }
    [cell.uploadedImageView setImage:[UIImage imageNamed:emotionFilename]];
    
    return cell;
}

- (NotificationTableViewCell*)populateCell:(NotificationTableViewCell*)cell forPhoto:(PhotoModel*)photoPost {
    
    NSString *notificationString = [NSString stringWithFormat:@"Uploaded a photo!"];
    [cell.notificationLabel setText:notificationString];
    [cell.uploadedImageView setImage:[UIImage imageNamed:@"icon-camera"]];
    
    [[TimelinePostController sharedInstance] getSignedImageURLForPath:photoPost.photoPath Completion:^(NSURL *url, NSError *error) {
        if (error) {
            DDLogError(@"%@",[error localizedDescription]);
        } else {
            [cell.uploadedImageView setImageWithURL:url];
        }
    }];
    
    return cell;
}

- (NotificationTableViewCell*)populateCell:(NotificationTableViewCell*)cell forPromise:(PromiseModel*)promisePost {
    
    NSString *notificationString = [NSString stringWithFormat:@"Promised: %@",promisePost.promiseContent];
    [cell.notificationLabel setText:notificationString];
    [cell.uploadedImageView setImage:[UIImage imageNamed:@"icon-promise"]];
    
    return cell;
}

@end
