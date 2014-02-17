//
//  TimelineViewController.m
//  Memoriz
//
//  Created by Nur Iman Izam on 27/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TimelineViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

#import "UserController.h"
#import "TimelinePostController.h"
#import "CommentsController.h"
#import "UserController.h"
#import "PointsController.h"
#import "EventsController.h"
#import "PromiseController.h"

#import "PhotoModel.h"
#import "PromiseModel.h"
#import "MessageModel.h"
#import "FacebookPhotoGroupModel.h"

#import "TimelinePhotoCell.h"
#import "TimelineMessageCell.h"
#import "TimelinePromiseCell.h"
#import "TimelineEventCell.h"
#import "FacebookPhotoCell.h"
#import "NSDate+TimeAgo.h"

#import "ProfileViewController.h"
#import "CommentsViewController.h"
#import "FacebookPhotoGroupViewController.h"
#import "FullPhotoViewController.h"

#import "AddPromiseViewController.h"
#import "ComposeMessageViewController.h"
#import "AddPhotoViewController.h"
#import "InviteEventViewController.h"

NSString *const TIMELINE_PHOTO_NIB = @"TimelinePhotoItem";
NSString *const TIMELINE_MESSAGE_NIB = @"TimelineMessageItem";
NSString *const TIMELINE_PROMISE_NIB = @"TimelinePromiseItem";
NSString *const TIMELINE_EVENT_NIB = @"TimelineEventItem";
NSString *const TIMELINE_FACEBOOK_PHOTO_NIB = @"FacebookPhotoCell";

@interface TimelineViewController ()

@property (nonatomic, strong) NSMutableArray *postsArray;
@property (nonatomic, strong) NSDictionary *timelineComments;

@end

@implementation TimelineViewController

#pragma mark - View Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    if (!IS_IPAD()) {
        [self setupTopViewController];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setStyling];
    [self initTableViewCells];
    [self initTableHeader];
    
    self.postsArray = [NSMutableArray array];
    
    [self loadPosts];
    [self loadPoints];
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
    [self setBottomBarView:nil];
    [self setFriendCoverImageView:nil];
    [self setPointsLabel:nil];
    [self setTableHeaderView:nil];
    [self setProfileButton:nil];
    [super viewDidUnload];
}

#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.postsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PostModel *post = [self.postsArray objectAtIndex:indexPath.row];
    UITableViewCell *cell;
    
    switch (post.postType) {
            
        case kMessagePost:
            cell = [self loadMessageCellForTableView:tableView Message:(MessageModel*)post];
            break;
        case kPhotoPost:
            cell = [self loadPhotoCellForTableView:tableView Photo:(PhotoModel*)post];
            break;
        case kPromisePost:
            cell = [self loadPromiseCellForTableView:tableView Promise:(PromiseModel*)post withIndexpath:indexPath];
            break;
        case kEventPost:
            cell = [self loadEventCellForTableView:tableView Event:(EventModel*)post withIndexpath:indexPath];
            break;
        case kFacebookPhotoGroupPost:
            cell = [self loadFacebookPhotoCellForTableView:tableView Photo:(FacebookPhotoGroupModel*)post];
        default:
            DDLogError(@"Post Type error");
            break;
    }
    
    return cell;
}


 - (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

     PostModel *post = [self.postsArray objectAtIndex:indexPath.row];
     CGSize constraintSize = {232.0f, INFINITY};
     
     if (post.postType == kMessagePost) {
         
         CGSize neededSize = [[(MessageModel*)post message] sizeWithFont:[UIFont fontWithName:OPENSANS_REGULAR size:13.0f] constrainedToSize:constraintSize];
         DDLogVerbose(@"needed height: %f",neededSize.height);
         return MAX(110.0f, neededSize.height+74.0f);
         
     } else if (post.postType == kPhotoPost || post.postType == kFacebookPhotoGroupPost) {
         
         return 220.0f;
         
     } else if (post.postType == kPromisePost) {
         
         CGSize neededSize = [[(PromiseModel*)post promiseContent] sizeWithFont:[UIFont fontWithName:OPENSANS_REGULAR size:13.0f] constrainedToSize:constraintSize];
         DDLogVerbose(@"needed height: %f",neededSize.height);
         return MAX(110.0f, neededSize.height+74.0f);
         
     } else if (post.postType == kEventPost){
         return 150.0f;
     } else {
         return 100.0f;
     }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostModel *post = [self.postsArray objectAtIndex:indexPath.row];
    
    if (post.postType == kFacebookPhotoGroupPost) {
        
        FacebookPhotoGroupModel *photoGroupModel = [self.postsArray objectAtIndex:indexPath.row];
        [self displayFacebookPhoto:photoGroupModel]; 
        
    } else {
        PostModel *postModel = [self.postsArray objectAtIndex:indexPath.row];
        [self displayCommentsForPost:postModel];
    }
}

#pragma mark - Scroll View Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (bottomBarState == kBottomBarStateShown) {
        bottomBarState = kBottomBarStateHidden;
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.bottomBarView setFrame:CGRectOffset(self.bottomBarView.frame, 0.0f, 55.0f)];
        } completion:nil];
    }
    
    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.frame.size.height)) {
        NSLog(@"user has scrolled to the bottom");
    }
}

#pragma mark - Button Actions

- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)friendButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

- (IBAction)profileButtonPressed:(id)sender {
    UINavigationController *profileNavigation = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
    ProfileViewController *profileView = [[profileNavigation viewControllers] objectAtIndex:0];
    profileView.userModel = self.friendModel;
    
    [self.navigationController pushViewController:profileView animated:YES];
}

- (IBAction)plusButtonPressed:(id)sender {
    if (bottomBarState == kBottomBarStateHidden) {
        
        // Stop scrolling
        if ([[self.tableView indexPathsForVisibleRows] count] > 1) {
            [self.tableView  scrollToRowAtIndexPath:[[self.tableView indexPathsForVisibleRows] objectAtIndex:1]  atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
        
        bottomBarState = kBottomBarStateShown;
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.bottomBarView setFrame:CGRectOffset(self.bottomBarView.frame, 0.0f, -55.0f)];
        } completion:nil];
    }
}

- (IBAction)composeButtonPressed:(id)sender {
    ComposeMessageViewController *composeMessageView = [self.storyboard instantiateViewControllerWithIdentifier:@"ComposeMessageView"];
    composeMessageView.delegate = self;
    composeMessageView.defaultActiveFriends = [[NSMutableArray alloc] initWithObjects:self.friendModel, nil];
    
    if (IS_IPAD()) {
        composeMessageView.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:composeMessageView animated:YES completion:nil];
}

- (IBAction)cameraButtonPressed:(id)sender {

    AddPhotoViewController *addPhotoView = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPhotoView"];
    addPhotoView.delegate = self;
    addPhotoView.defaultActiveFriends = [[NSMutableArray alloc] initWithObjects:self.friendModel, nil];
    
    if (IS_IPAD()) {
        addPhotoView.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:addPhotoView animated:YES completion:nil];
}

- (IBAction)newPromiseButtonPressed:(id)sender {
    AddPromiseViewController *promiseView = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPromiseView"];
    promiseView.delegate = self;
    promiseView.friendModel = self.friendModel;
    
    if (IS_IPAD()) {
        promiseView.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentModalViewController:promiseView animated:YES];
}

- (IBAction)eventButtonPressed:(id)sender {
    InviteEventViewController *inviteEventView = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteEventView"];
    inviteEventView.delegate = self;
    inviteEventView.friendModel = self.friendModel;
    
    if (IS_IPAD()) {
        inviteEventView.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentModalViewController:inviteEventView animated:YES];
}

#pragma mark - Compose View Delegate Methods

- (void)composeViewController:(UIViewController *)viewController didCompose:(PostModel *)postModel {

    // Insert New Post
    if (postModel) {
        [self.postsArray insertObject:postModel atIndex:0];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self loadPoints];
    }
}

- (void)composeViewController:(UIViewController*)viewController didCommentForPost:(PostModel*)postModel {
    [self.tableView reloadData];
}

#pragma mark - Helper Functions

- (void)setStyling {
    [self.menuButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.friendButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.profileButton.titleLabel setFont:[UIFont fontWithName:OPENSANS_SEMIBOLD size:15.0f]];
    [self.pointsLabel setFont:[UIFont fontWithName:OPENSANS_REGULAR size:40.0f]];
    
    bottomBarState = kBottomBarStateHidden;
    
    if (IS_IPAD()) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    self.title = [self.friendModel objectForKey:@"displayName"];
}

- (void)initTableViewCells {

    UINib *messageCellNib = [UINib nibWithNibName:TIMELINE_MESSAGE_NIB bundle:nil];
    UINib *photoCellNib = [UINib nibWithNibName:TIMELINE_PHOTO_NIB bundle:nil];
    UINib *promiseCellNib = [UINib nibWithNibName:TIMELINE_PROMISE_NIB bundle:nil];
    UINib *eventCellNib = [UINib nibWithNibName:TIMELINE_EVENT_NIB bundle:nil];
    UINib *facebookPhotoCellNib = [UINib nibWithNibName:TIMELINE_FACEBOOK_PHOTO_NIB bundle:nil];
    
    [self.tableView registerNib:messageCellNib forCellReuseIdentifier:TIMELINE_MESSAGE_NIB];
    [self.tableView registerNib:photoCellNib forCellReuseIdentifier:TIMELINE_PHOTO_NIB];
    [self.tableView registerNib:promiseCellNib forCellReuseIdentifier:TIMELINE_PROMISE_NIB];
    [self.tableView registerNib:eventCellNib forCellReuseIdentifier:TIMELINE_EVENT_NIB];
    [self.tableView registerNib:facebookPhotoCellNib forCellReuseIdentifier:TIMELINE_FACEBOOK_PHOTO_NIB];
}

- (void)initTableHeader {
    
    // Init TableHeader
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    if (self.friendModel) {
        [[UserController sharedInstance] fetchFacebookCoverURLForFacebookId:[self.friendModel objectForKey:@"facebookId"] WithCompletionHandler:^(NSURL *coverURL, NSError *error) {
            if (!error) {
                [self.friendCoverImageView setImageWithURL:coverURL placeholderImage:[UIImage imageNamed:@""]];
            }
        }];
    }
}

- (void)loadPosts {  
    [[TimelinePostController sharedInstance] getTimelinePostsWithUserID:self.friendModel.objectId withCompletion:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            [self.postsArray removeAllObjects];
            [self.postsArray addObjectsFromArray:objects];
            [self.postsArray sortUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO] ] ];
            DDLogVerbose(@"%@: %@, PostsArray: %@",THIS_FILE,THIS_METHOD,self.postsArray);
            
            [self.tableView reloadData];
        } else {
            DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,[error localizedDescription]);
        }
        
    }];
}

- (void)loadPoints {
    [[PointsController sharedInstance] getCurrentPointsWithUserID:self.friendModel.objectId WithCompletionHandler:^(PointModel *points) {
        [self.pointsLabel setText:[NSString stringWithFormat:@"%d",points.points]];
    }];
}

- (void)displayFacebookPhoto:(FacebookPhotoGroupModel *)photoGroupModel {
    if ([photoGroupModel.facebookPhotos count] > 1) { // Display List of Images
        
        FacebookPhotoGroupViewController *photoGroupView = [self.storyboard instantiateViewControllerWithIdentifier:@"FacebookPhotoGroupView"];
        photoGroupView.facebookGroupModel = photoGroupModel;
        [self removeGestures];
        [self.navigationController pushViewController:photoGroupView animated:YES];
        
    } else if ([photoGroupModel.facebookPhotos count] == 1) { // Display Full Image Immediately
        
        FullPhotoViewController *photoView = [self.storyboard instantiateViewControllerWithIdentifier:@"FullPhotoView"];
        FacebookPhotoModel *photoModel = [photoGroupModel.facebookPhotos objectAtIndex:0];
        photoView.photoURL = photoModel.bigPhotoURL;
        [self removeGestures];
        [self.navigationController pushViewController:photoView animated:YES];
    } // End If Photo Count
}

- (void)displayCommentsForPost:(PostModel *)postModel {
    CommentsViewController *commentsView = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentsView"];
    commentsView.postModel = postModel;
    commentsView.delegate = self;
    [self removeGestures];
    [self.navigationController pushViewController:commentsView animated:YES];
}

#pragma mark - UITableView Cell Helpers

- (UITableViewCell*)loadPhotoCellForTableView:(UITableView *)tableView Photo:(PhotoModel*)photo
{
    
    TimelinePhotoCell *cell = (TimelinePhotoCell*)[tableView dequeueReusableCellWithIdentifier:TIMELINE_PHOTO_NIB];
    [cell setStyling];
    
    [[UserController sharedInstance] fetchFacebookIDForUser:photo.creatorUserID WithCompletionHandler:^(NSString *facebookID) {
        if (facebookID) {
            NSURL *profileUrl = [Constants facebookProfileImageURLWithId:facebookID andCGSize:CGSizeMake(80, 80)];
            [cell.userImageView setImageWithURL:profileUrl placeholderImage:[UIImage imageNamed:@"profile-default"]];
        }
    }];
    
    [cell.createAt setText:[photo.createdAt timeAgo]];
    
    [[TimelinePostController sharedInstance] getSignedImageURLForPath:photo.photoPath Completion:^(NSURL *url, NSError *error) {
        if (error) {
            DDLogError(@"%@",[error localizedDescription]);
        } else {
            [cell.photo setImageWithURL:url];
        }
    }];
    
    cell.commentCountLabel.text = [NSString stringWithFormat:@"%d", photo.commentCount];
    
    return cell;
}

- (UITableViewCell*)loadFacebookPhotoCellForTableView:(UITableView *)tableView Photo:(FacebookPhotoGroupModel*)photoGroup
{
    
    FacebookPhotoCell *cell = (FacebookPhotoCell*)[tableView dequeueReusableCellWithIdentifier:TIMELINE_FACEBOOK_PHOTO_NIB];
    [cell setStyling];
    [cell.timeAgoLabel setText:[photoGroup.createdAt timeAgo]];
    
    if ([photoGroup.facebookPhotos count] > 0) {
        FacebookPhotoModel *photoModel = [photoGroup.facebookPhotos objectAtIndex:0];
        [cell.mainImageView setImageWithURL:photoModel.bigPhotoURL placeholderImage:[UIImage imageNamed:@""]];
    }
    
    return cell;
}

- (UITableViewCell*)loadMessageCellForTableView:(UITableView *)tableView Message:(MessageModel*)message
{
    TimelineMessageCell *cell = (TimelineMessageCell*)[tableView dequeueReusableCellWithIdentifier:TIMELINE_MESSAGE_NIB];
    [cell setStyling];
    
    [[UserController sharedInstance] fetchFacebookIDForUser:message.creatorUserID WithCompletionHandler:^(NSString *facebookID) {
        if (facebookID) {
            NSURL *profileUrl = [Constants facebookProfileImageURLWithId:facebookID andCGSize:CGSizeMake(80, 80)];
            [cell.userImageView setImageWithURL:profileUrl placeholderImage:[UIImage imageNamed:@"profile-default"]];
        }
    }];
    
    [cell.message setText:message.message];
    if (!message.emotionNumber) {
        message.emotionNumber = 1;
    }

    CGSize constraintSize = {232.0f, INFINITY};
    
    CGSize neededSize = [message.message sizeWithFont:[UIFont fontWithName:OPENSANS_REGULAR size:13.0f] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect newFrame = cell.message.frame;
    newFrame.size.height = MAX(26.0f, neededSize.height);
    [cell.message setFrame: newFrame];
    
    [cell.emotionStatus setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", message.emotionNumber]]];
    [cell.postTime setText:[message.createdAt timeAgo]];
    
    cell.commentsCountLabel.text = [NSString stringWithFormat:@"%d", message.commentCount];

    
    return cell;
}

- (UITableViewCell*)loadPromiseCellForTableView:(UITableView *)tableView Promise:(PromiseModel*)promise withIndexpath:(NSIndexPath*)indexPath
{
    TimelinePromiseCell *cell = (TimelinePromiseCell*)[tableView dequeueReusableCellWithIdentifier:TIMELINE_PROMISE_NIB];
    [cell setStyling];
    cell.indexPath = indexPath;
    cell.delegate = self;

    if ([promise.fulfillment intValue] == 1) {
        if ([promise.creatorUserID isEqualToString:[[UserController sharedInstance] fetchCurrentUser].objectId]) {
            [cell hideButtons:YES];
            [cell.fulfilledLabel setText:@"Awaiting Decision"];
        } else {
            [cell hideButtons:NO];
        }
    } else {
        [cell hideButtons:YES];
        
        if ([promise. fulfillment intValue] == 2) {
            [cell.fulfilledLabel setText:@"Fulfilled"];
        } else {
            [cell.fulfilledLabel setText:@"Not Fulfilled"];
        }
    }
    
    [[UserController sharedInstance] fetchFacebookIDForUser:promise.creatorUserID WithCompletionHandler:^(NSString *facebookID) {
        if (facebookID) {
            NSURL *profileUrl = [Constants facebookProfileImageURLWithId:facebookID andCGSize:CGSizeMake(80, 80)];
            [cell.profilePic setImageWithURL:profileUrl placeholderImage:[UIImage imageNamed:@"profile-default"]];
        }
    }];
    
    CGSize constraintSize = {232.0f, INFINITY};
    
    CGSize neededSize = [promise.promiseContent sizeWithFont:[UIFont fontWithName:OPENSANS_REGULAR size:13.0f] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect newFrame = cell.promiseContent.frame;
    newFrame.size.height = MAX(26.0f, neededSize.height);
    [cell.promiseContent setFrame: newFrame];
    
    [cell.promiseContent setText:promise.promiseContent];
    [cell.postedTime setText:[promise.createdAt timeAgo]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [cell.deadlineLabel setText:[dateFormatter stringFromDate:promise.promiseDeadline]];
    
    cell.commentsCountLabel.text = [NSString stringWithFormat:@"%d", promise.commentCount];

    
    return cell;
}

- (UITableViewCell*)loadEventCellForTableView:(UITableView *)tableView Event:(EventModel*)event withIndexpath:(NSIndexPath*)indexPath
{
    TimelineEventCell *cell = (TimelineEventCell*)[tableView dequeueReusableCellWithIdentifier:TIMELINE_EVENT_NIB];
    
    [cell setStyling];
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    [[UserController sharedInstance] fetchFacebookIDForUser:event.creatorUserID WithCompletionHandler:^(NSString *facebookID) {
        if (facebookID) {
            NSURL *profileUrl = [Constants facebookProfileImageURLWithId:facebookID andCGSize:CGSizeMake(80, 80)];
            [cell.profilePic setImageWithURL:profileUrl placeholderImage:[UIImage imageNamed:@"profile-default"]];
        }
    }];
    
    if (![[[UserController sharedInstance] fetchCurrentUser].objectId isEqualToString:event.creatorUserID]) {
        [cell hideButtons:NO];
    } else {
        [cell hideButtons:YES];
    }
    
    cell.eventName.text = event.name;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMM yy, h:mma"];
    
    if ([event.endTime compare:event.startTime]) {
        cell.eventTime.text = [NSString stringWithFormat:@"Time: %@ - %@",
                               [dateFormatter stringFromDate:event.startTime],
                               [dateFormatter stringFromDate:event.endTime]];
    } else {
        cell.eventTime.text = [NSString stringWithFormat:@"Time: %@", [dateFormatter stringFromDate:event.startTime]];
    }
    
    if ([event.location compare:@""]) {
        cell.eventLocation.text = [NSString stringWithFormat:@"Location: %@", event.location];
    } else {
        cell.eventLocation.text = @"Location: Unknown";
    }

    cell.postTime.text = [event.createdAt timeAgo];
    cell.commentCountLabel.text = [NSString stringWithFormat:@"%d", event.commentCount];
    
    return cell;
}

#pragma mark - TimelinePromiseCellDelegate Methods

- (void)promiseCell:(id)cell didPressAcceptAtIndexPath:(NSIndexPath *)indexPath {
    PromiseModel *promiseModel = [self.postsArray objectAtIndex:indexPath.row];
    
    [SVProgressHUD showWithStatus:@"Updating..." maskType:SVProgressHUDMaskTypeGradient];
    [PromiseController acceptFulfillments:promiseModel.objectId withCompletionHandler:^(NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"Promise Updated!"];
            [self loadPosts];
        } else {
            [SVProgressHUD showErrorWithStatus:@"An error occurred. Try again."];
        }
    }];
}

- (void)promiseCell:(id)cell didPressRejectAtIndexPath:(NSIndexPath *)indexPath {
    PromiseModel *promiseModel = [self.postsArray objectAtIndex:indexPath.row];
    [SVProgressHUD showWithStatus:@"Updating..." maskType:SVProgressHUDMaskTypeGradient];
    [PromiseController rejectFulfillments:promiseModel.objectId withCompletionHandler:^(NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"Promise Updated!"];
            [self loadPosts];
        } else {
            [SVProgressHUD showErrorWithStatus:@"An error occurred. Try again."];
        }
    }];
}

#pragma mark - TimelineEventCellDelegate Methods 

- (void)eventCell:(id)cell didPressGoing:(NSIndexPath *)indexPath {
    EventModel *eventModel = [self.postsArray objectAtIndex:indexPath.row];
    
    [SVProgressHUD showWithStatus:@"Updating Facebook..." maskType:SVProgressHUDMaskTypeGradient];
    [EventsController goingToEvent:eventModel Completion:^(NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"Facebook Updated!"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"An error occurred. Try again."];
        }
    }];
}

@end
