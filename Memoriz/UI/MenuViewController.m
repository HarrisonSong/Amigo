//
//  MenuViewController.m
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 19/3/13.
//  Copyright (c) 2013 imanism. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "FriendsController.h"
#import "UserController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

#pragma mark - View Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return kMenuSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
            
        case kMenuSectionOthers:
            return kOthersSectionTypeCount;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *labelString = @"";
    NSString *imageString = @"";
    if (indexPath.section == kMenuSectionOthers) {
        
        switch (indexPath.row) {
                
            case kOthersSectionTypeHome:
                labelString = @"Home";
                imageString = @"icon-home";
                break;
                
            case kOthersSectionTypeProfile:
                labelString = @"Profile";
                imageString = @"icon-profile";
                break;
                
            case kOthersSectionTypeHelp:
                labelString = @"Help Center";
                imageString = @"icon-help";
                break;
                
            case kOthersSectionTypeLogout:
                labelString = @"Log out";
                imageString = @"icon-logout";
                break;
                
            default:
                labelString = @"Unknown";
                imageString = @"";
                break;
        }
    }
    
    [cell.mainIcon setImage:[UIImage imageNamed:imageString]];
    [cell.mainLabel setText:labelString];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == kMenuSectionOthers) {
        
        UIActionSheet *actionSheet;
        UIViewController *viewController;
        
        switch (indexPath.row) {
                
            case kOthersSectionTypeHome:
                viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
                break;
            case kOthersSectionTypeProfile:
                viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
                break;
            case kOthersSectionTypeHelp:
                viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpView"];
                break;
                
            case kOthersSectionTypeLogout:
                 actionSheet = [[UIActionSheet alloc] initWithTitle:@"Log out"
                                             delegate:self
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:@"Logout"
                                    otherButtonTitles:nil];
                [actionSheet showInView:self.view];
                
                break;
            default:
                
                break;
        }
        
        if (viewController) {
            [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
                CGRect frame = self.slidingViewController.topViewController.view.frame;
                self.slidingViewController.topViewController = viewController;
                self.slidingViewController.topViewController.view.frame = frame;
                [self.slidingViewController resetTopView];
            }];
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

#pragma mark - Helper Functions

- (void)setStyling {
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"underbg"]]];
}


@end
