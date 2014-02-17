//
//  FriendsViewController.m
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FriendsViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UIImageView+AFNetworking.h"

#import "SliderViewController.h"
#import "SplitViewController.h"
#import "TimelineViewController.h"

#import "EmoticonController.h"
#import "PointsController.h"
#import "FriendsController.h"
#import "TimelinePostController.h"

@interface FriendsViewController ()

@property (nonatomic, strong) NSArray *friendsArray;
@property (nonatomic, strong) NSArray *requestsArray;
@property (nonatomic, strong) NSArray *invitationArray;

@end

@implementation FriendsViewController

#pragma mark - View Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [self loadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setStyling];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:PointsControllerDidUpdatePoints object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return kFriendsMenuTypeCount;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    [headerView setBackgroundColor:[UIColor colorWithRed:0.137254902f green:0.137254902f blue:0.137254902f alpha:1.0f]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 260, 40)];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setTextAlignment:NSTextAlignmentLeft];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setFont:[UIFont fontWithName:OPENSANS_BOLD size:19.0f]];
    [headerView addSubview:headerLabel];
    
    if (IS_IPAD()) {
        [headerLabel setFrame:CGRectMake(20, 0, 260, 40)];
    }
    
    UIImageView *separatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0,39, 320, 1)];
    [separatorView setImage:[UIImage imageNamed:@"separator"]];
    [headerView addSubview:separatorView];
    
    switch (section) {
        case kFriendsMenuTypeFriends:
            [headerLabel setText:[NSString stringWithFormat:@"Amigos (%d/5)",[self.friendsArray count]]];
            break;
            
        case kFriendsMenuTypeRequests:
            [headerLabel setText:@"Pending Request"];
            break;
            
        case kFriendsMenuTypeInvitations:
            [headerLabel setText:@"Your Requests"];
            break;
            
        case kFriendsMenuTypeOthers:
            return nil;
            break;
            
        default:
            return nil;
            break;
    }

    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == kFriendsMenuTypeOthers)
        return 0.0f;
    else if (section == kFriendsMenuTypeRequests) {
        if ([self.requestsArray count] == 0)
            return 0.0f;
        return 40.0f;
        
    } else if (section == kFriendsMenuTypeInvitations) {
        if ([self.invitationArray count] == 0)
            return 0.0f;
        return 40.0f;
        
    } else { // (section == kFriendsMenuTypeFriends)
        if ([self.friendsArray count] == 0)
            return 0.0f;
        return 40.0f;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kFriendsMenuTypeOthers) {
        return 60.0f;
    } else {
        return 100.0f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case kFriendsMenuTypeFriends:
            return [self.friendsArray count];
            break;
            
        case kFriendsMenuTypeRequests:
            return [self.requestsArray count];
            break;
        
        case kFriendsMenuTypeInvitations:
            return [self.invitationArray count];
            break;
            
        case kFriendsMenuTypeOthers:
            if (IS_IPAD()) {
                return kFriendsiPadMenuTypeOthersTypeCount;
            } else {
                return 1;
            }
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == kFriendsMenuTypeFriends) {
        
        cell = [self loadFriendCellForTableView:self.tableView withUser:[self.friendsArray objectAtIndex:indexPath.row]];
        
    } else if (indexPath.section == kFriendsMenuTypeRequests) {
        
        cell = [self loadFriendCellForTableView:self.tableView withRequest:[self.requestsArray objectAtIndex:indexPath.row] atIndexPath:indexPath];
        
    } else if (indexPath.section == kFriendsMenuTypeInvitations) {
            
        cell = [self loadInvitationCellForTableView:self.tableView withFacebookId:[self.invitationArray objectAtIndex:indexPath.row] atIndexPath:indexPath];
        
    } else { // Others
        
        if (IS_IPAD()) {
            switch (indexPath.row) {
                case kFriendsiPadMenuTypeOthersTypeHome:
                    cell = [self loadMenuCellForTableView:self.tableView
                                                withTitle:@"Home"
                                                 AndImage:[UIImage imageNamed:@"icon-home"]];
                    break;
                    
                case kFriendsiPadMenuTypeOthersTypeProfile:
                    cell = [self loadMenuCellForTableView:self.tableView
                                                withTitle:@"Profile"
                                                 AndImage:[UIImage imageNamed:@"icon-profile"]];
                    break;
                    
                case kFriendsiPadMenuTypeOthersTypeHelp:
                    cell = [self loadMenuCellForTableView:self.tableView
                                                withTitle:@"Help"
                                                 AndImage:[UIImage imageNamed:@"icon-help"]];
                    break;
                    
                case kFriendsiPadMenuTypeOthersTypeLogout:
                    cell = [self loadMenuCellForTableView:self.tableView
                                                withTitle:@"Logout"
                                                 AndImage:[UIImage imageNamed:@"icon-logout"]];
                    break;
                    
                case kFriendsiPadMenuTypeOthersTypeInvite:
                    cell = [self loadMenuCellForTableView:self.tableView
                                                withTitle:@"Invite Friends"
                                                 AndImage:[UIImage imageNamed:@"icon-invite"]];
                    break;
                    
                default:
                    break;
            }
        } else {
            cell = [self loadMenuCellForTableView:self.tableView
                                        withTitle:@"Invite Friends"
                                         AndImage:[UIImage imageNamed:@"icon-invite"]];
        }
    }
    
    return cell;
}

- (UITableViewCell*)loadFriendCellForTableView:(UITableView *)tableView withRequest:(UserModel*)requestUser atIndexPath:(NSIndexPath*)indexPath {
    
    FriendRequestTableViewCell *cell = (FriendRequestTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"RequestCell"];
    [cell setStyling];
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    if (requestUser) {
        [cell.nameLabel setText: [requestUser objectForKey:@"displayName"]];
        NSURL *profileImageUrl = [Constants facebookProfileImageURLWithId:[requestUser objectForKey:@"facebookId"] andCGSize:CGSizeMake(160, 160)];
        [cell.profileImageView setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:@"profile-default"]];
    }

    return cell;
}

- (UITableViewCell*)loadInvitationCellForTableView:(UITableView *)tableView withFacebookId:(NSString*)facebookId atIndexPath:(NSIndexPath*)indexPath {
    
    FriendInvitationTableViewCell *cell = (FriendInvitationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"InvitationCell"];
    [cell setStyling];
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    if (facebookId) {
        
        [FBRequestConnection startWithGraphPath:facebookId parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            NSLog(@"Invitation Cell Facebook Details: %@",result);
            [cell.nameLabel setText: [result objectForKey:@"name"]];
        }];
        
        NSURL *profileImageUrl = [Constants facebookProfileImageURLWithId:facebookId andCGSize:CGSizeMake(160, 160)];
        [cell.profileImageView setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:@"profile-default"]];
    }
    
    return cell;
}

- (UITableViewCell*)loadFriendCellForTableView:(UITableView *)tableView withUser:(UserModel*)user {
    
    FriendsTableViewCell *cell = (FriendsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"FriendsCell"];
    [cell setStyling];
    
    if (user) {
        
        [cell.nameLabel setText: [user objectForKey:@"displayName"]];
        
        [[PointsController sharedInstance] getCurrentPointsWithUserID:user.objectId WithCompletionHandler:^(PointModel *points) {
            [cell.latestLabel setText:[NSString stringWithFormat:@"%d",points.points]];
        }];
        
        NSURL *profileImageUrl = [Constants facebookProfileImageURLWithId:[user objectForKey:@"facebookId"] andCGSize:CGSizeMake(160, 160)];
        [cell.profileImageView setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:@"profile-default"]];
        
    }
    
    return cell;
}

- (UITableViewCell*)loadMenuCellForTableView:(UITableView *)tableView withTitle:(NSString*)title AndImage:(UIImage*)image {
    
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    [cell setStyling];
    if (title) {
        [cell.mainLabel setText:title];
    }
    
    if (image) {
        [cell.mainIcon setImage:image];
    }
    
    return cell;
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     // Return NO if you do not want the specified item to be editable.
     return YES;
 }

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == kFriendsMenuTypeFriends) {
        
        UINavigationController *timelineNavigation = [self.storyboard instantiateViewControllerWithIdentifier:@"TimelineView"];
        
        TimelineViewController *timelineView = [[timelineNavigation viewControllers] objectAtIndex:0];
        timelineView.friendModel = [self.friendsArray objectAtIndex:indexPath.row];
        
        if (IS_IPAD()) {
            
            SplitViewController *splitView = (SplitViewController*)self.parentViewController.parentViewController;
            NSLog(@"%@",splitView);
            
            NSArray *newVCs = @[[splitView.viewControllers objectAtIndex:0], timelineNavigation];
            splitView.viewControllers = newVCs;
            
        } else {
            
            [self.slidingViewController anchorTopViewOffScreenTo:ECLeft animations:nil onComplete:^{
                CGRect frame = self.slidingViewController.topViewController.view.frame;
                self.slidingViewController.topViewController = timelineNavigation;
                self.slidingViewController.topViewController.view.frame = frame;
                [self.slidingViewController resetTopView];
            }];
        }
        
    } else if (indexPath.section == kFriendsMenuTypeOthers) {
        
        if (IS_IPAD()) {
            
            UIActionSheet *actionSheet;
            UIViewController *viewController;
            CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
            
            switch (indexPath.row) {
                case kFriendsiPadMenuTypeOthersTypeHome:
                    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
                    break;
                    
                case kFriendsiPadMenuTypeOthersTypeProfile:
                    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
                    break;
                    
                case kFriendsiPadMenuTypeOthersTypeHelp:
                    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpView"];
                    break;
                    
                case kFriendsiPadMenuTypeOthersTypeLogout:
                    
                    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:@"Logout"
                                                     otherButtonTitles:nil];
                    [actionSheet showFromRect:cellRect inView:self.view animated:YES];
                    break;
                    
                case kFriendsiPadMenuTypeOthersTypeInvite:
                    [self loadFacebookInvite];
                    break;
                    
                default:
                    break;
            }
            
            
            // Load ViewController
            if (viewController) {
                SplitViewController *splitView = (SplitViewController*)self.parentViewController.parentViewController;
                NSLog(@"%@",splitView);
                
                NSArray *newVCs = @[[splitView.viewControllers objectAtIndex:0], viewController];
                splitView.viewControllers = newVCs;
            }
    
            
        } else {
            [self loadFacebookInvite];
        }
        
    }

}

#pragma mark - UIActionSheet Delegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    DDLogVerbose(@"%@: %@:%d",THIS_FILE,THIS_METHOD,buttonIndex);
    
    if (buttonIndex == 0) {
        [[UserController sharedInstance] logout];
        UIViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        loginView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:loginView animated:YES];
    }
}

#pragma mark - FriendInvitationTableViewCell Delegate Methods

- (void)invitationCell:(id)cell didPressCancelAtIndexPath:(NSIndexPath *)indexPath {
    NSString *friendFacebookId = [self.invitationArray objectAtIndex:indexPath.row];
    [SVProgressHUD showWithStatus:@"Cancelling request..." maskType:SVProgressHUDMaskTypeGradient];
    [FriendsController deleteInvition:friendFacebookId withCompletion:^(NSError *error) {
        if(!error){
            [self loadData];
            [SVProgressHUD showSuccessWithStatus:@"Cancel request successful!"];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"Cancel request failed.. Try again."];
        }
    }];
}

#pragma mark - FriendRequestTableViewCell Delegate Methods

- (void)requestCell: (id)cell didPressAcceptAtIndexPath:(NSIndexPath*)indexPath {
    UserModel *userData = [self.requestsArray objectAtIndex:indexPath.row];
    
    [SVProgressHUD showWithStatus:@"Accepting request..." maskType:SVProgressHUDMaskTypeGradient];
    [FriendsController acceptInviteRequest:userData.objectId withCompletion:^(NSError *error) {
        if(!error){
            [self loadData];
            [SVProgressHUD showSuccessWithStatus:@"Accept request successful!"];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"Accept request failed.. Try again."];
        }
    }];
}

- (void)requestCell: (id)cell didPressRejectAtIndexPath:(NSIndexPath*)indexPath {
    UserModel *userData = [self.requestsArray objectAtIndex:indexPath.row];
    
    [SVProgressHUD showWithStatus:@"Rejecting request..." maskType:SVProgressHUDMaskTypeGradient];
    [FriendsController rejectInviteRequest:userData.objectId withCompletion:^(NSError *error) {
        if(!error){
            [self loadData];
            [SVProgressHUD showSuccessWithStatus:@"Reject request successful!"];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"Reject request failed.. Try again."];
        }
    }];
}

#pragma mark - Helper Functions

- (void)setStyling {
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"underbg"]]];
}

- (void)loadData {
    [FriendsController getFriendsListWithCompletionHandler:^(NSArray *friendsArray, NSError *error) {
        
        if (!error) {
            self.friendsArray = friendsArray;
            DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,self.friendsArray);
            [self.tableView reloadData];
        }
        
    }];
    
    [FriendsController getInviteRequestsWithCompletionHandler:^(NSArray *requestsArray, NSError *error) {
        if(!error){
            self.requestsArray = requestsArray;
            DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,self.requestsArray);
            [self.tableView reloadData];
        }
    }];
    
    [FriendsController getinvitionWithCompletionHandler:^(NSArray *invitationArray, NSError *error) {
        if(!error){
            self.invitationArray = invitationArray;
            DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,self.requestsArray);
            [self.tableView reloadData];
        }
    }];
}

- (void)loadFacebookInvite {
    [[FriendsController sharedInstance] getInviteRequestCurrentFriendListWithCompletionHandler:^(NSArray *friendsArray, NSError *error) {
        if(!error){
            NSMutableArray *excludeFriends = [[NSMutableArray alloc] init];
            for(NSString * friend in friendsArray){
                [excludeFriends addObject:friend];
            }
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [excludeFriends componentsJoinedByString:@","], @"exclude_ids",nil];
            [FBWebDialogs presentRequestsDialogModallyWithSession:nil message:[NSString stringWithFormat:@"Come and join me for a private timeline in Amigo!"] title:@"Invite Friends" parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                if (error) {
                    // Case A: Error launching the dialog or sending request.
                    DDLogVerbose(@"Error sending request.");
                } else {
                    if (result == FBWebDialogResultDialogNotCompleted) {
                        // Case B: User clicked the "x" icon
                        DDLogVerbose(@"User canceled request.");
                    } else {
                        NSArray *facebookIDArray = [self parseFacebookIDsFromURL:resultURL];
                        DDLogVerbose(@"Request Sent to: %@",facebookIDArray);
                        
                        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
                        [FriendsController inviteFriends:facebookIDArray withCompletionHandler:^(NSError *error) {
                            if (error)
                                [SVProgressHUD showErrorWithStatus:@"An error occurred."];
                            else {
                                [SVProgressHUD showSuccessWithStatus:@"Friends successfully invited."];
                                [self loadData];
                            }
                        }];
                        
                    }
                }
            }];

        }
    }];
}

- (NSArray*)parseFacebookIDsFromURL:(NSURL*)resultURL {
    
    NSString *urlString = [resultURL absoluteString];
    
    NSMutableArray *facebookIDs = [[NSMutableArray alloc] init];
    
    NSArray *pairs = [urlString componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSArray *keyValue = [pair componentsSeparatedByString:@"="];
        NSString *value = [[keyValue objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [facebookIDs addObject:value];
    }
    
    // Remove Request ID
    [facebookIDs removeObjectAtIndex:0];
    
    return facebookIDs;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
 
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
