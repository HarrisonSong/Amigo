//
//  ProfileViewController.m
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ProfileViewController.h"
#import "EmoticonPopoverView.h"
#import "EmoticonController.h"
#import "TimelinePostController.h"
#import "AchievementController.h"

@interface ProfileViewController ()

@property (nonatomic, strong) NSDictionary *facebookData;

@end

@implementation ProfileViewController

#pragma mark - UIViewController Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    // Only add topviewcontroller settings if display current user profile on iPhone.
    if ([self isRootViewController] && !IS_IPAD()) {
            [self setupTopViewController];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setStyling];
    
    if (!self.userModel) {
        self.userModel = [[UserController sharedInstance] fetchCurrentUser];

        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            NSLog(@"RESULT: %@",result);
            self.facebookData = result;
            [self updateUserLabels];
        }];
        
    } else {
        
        [FBRequestConnection startWithGraphPath:[self.userModel objectForKey:@"facebookId"] parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            NSLog(@"RESULT2: %@",result);
            self.facebookData = result;
            [self updateUserLabels];
        }];
    }
    
    [self loadProfileData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMenuButton:nil];
    [self setProfileImage:nil];
    [self setCoverImageView:nil];
    [self setFriendButton:nil];
    [self setBirthdayLabel:nil];
    [self setBioLabel:nil];
    [self setLocationLabel:nil];
    [self setNameLabel:nil];
    [self setAmigoCountLabel:nil];
    [self setPostCountLabel:nil];
    [self setPointsCountLabel:nil];
    [self setAchievementLabel:nil];
    [self setAchievementImageViews:nil];
    [self setScrollView:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}

#pragma mark - Button Actions

- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)friendButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

- (void)backbuttonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper Functions

- (BOOL)isRootViewController {
    return [[self.navigationController viewControllers] count] == 1;
}
- (void)setStyling {

    [self.friendButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // Show Menu Button if Current User Profile
    if ([self isRootViewController]) {
        [self.menuButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        
    } else { // Show Back Button for other profiles
        UIImage *backButtonImage = [UIImage imageNamed:@"icon-back"];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(backbuttonPressed)];
        [backButtonItem setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }
    
    [self.profileImage.layer setMasksToBounds:NO];
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImage.layer.borderWidth = 1.0f;
    
    if (IS_IPAD()) {
        self.navigationItem.rightBarButtonItem = nil;
        
        if ([[self.navigationController viewControllers] count] == 1) {
            self.navigationItem.leftBarButtonItem = nil;
        }
    } else {
        
        [self.scrollView setContentSize:self.contentView.frame.size];
        
    }
}

- (void)updateUserLabels {
    
    [self.birthdayLabel setText:[self.facebookData objectForKey:@"birthday"]];
    [self.bioLabel setText:[self.facebookData objectForKey:@"bio"]];
    [self.nameLabel setText:[self.facebookData objectForKey:@"name"]];
    
    if ([self.facebookData objectForKey:@"location"]) {
        [self.locationLabel setText:[[self.facebookData objectForKey:@"location"] objectForKey:@"name"]];
    }
}

- (void)activateAchievement:(AchievementModel*)achievement {
    for (UIImageView* achievementImageView in self.achievementImageViews) {
        if (achievementImageView.tag == [[achievement objectForKey:@"id"] intValue]) {
            NSLog(@"Achievement activated: %d",[[achievement objectForKey:@"id"] intValue]);
            [achievementImageView setAlpha:1.0];
            break;
        }
    }
}

- (void)loadProfileData {
    [[TimelinePostController sharedInstance] getPostsNumberWithUserID:self.userModel.objectId withCompletion:^(NSNumber * count, NSError *error) {
        if (!error) {
            DDLogVerbose(@"%@: %@, Post Count: %@",THIS_FILE,THIS_METHOD,count);
            [self.postCountLabel setText:[NSString stringWithFormat:@"%@",count]];
        } else {
            DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,[error localizedDescription]);
        }
    }];
    
    [[TimelinePostController sharedInstance] getTotalPointsWithUserID:self.userModel.objectId withCompletion:^(int count, NSError *error) {
        if (!error) {
            DDLogVerbose(@"%@: %@, Points Count: %d",THIS_FILE,THIS_METHOD,count);
            [self.pointsCountLabel setText:[NSString stringWithFormat:@"%d",count]];
        } else {
            DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,[error localizedDescription]);
        }
    }];
    
    [[TimelinePostController sharedInstance] getFriendsNumberWithUserID:self.userModel.objectId withCompletion:^(int count, NSError *error) {
        if (!error) {
            DDLogVerbose(@"%@: %@, Friends Count: %d",THIS_FILE,THIS_METHOD,count);
            [self.amigoCountLabel setText:[NSString stringWithFormat:@"%d",count]];
        } else {
            DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,[error localizedDescription]);
        }
    }];
    
    [[AchievementController sharedInstance] getAchievementsForUser:self.userModel.objectId withCompletionHandler:^(NSArray *achievements, NSError *error) {
        DDLogVerbose(@"Achievements: %@",achievements);
        for (AchievementModel* achievement in achievements) {
            [self activateAchievement:achievement];
        }
    }];
    
    [[UserController sharedInstance] fetchFacebookCoverURLForFacebookId:[self.userModel objectForKey:@"facebookId"] WithCompletionHandler:^(NSURL *coverURL, NSError *error) {
        [self.coverImageView setImageWithURL:coverURL placeholderImage:[UIImage imageNamed:@""]];
    }];
    
    NSURL *profileUrl = [Constants facebookProfileImageURLWithId:[self.userModel objectForKey:@"facebookId"] andCGSize:CGSizeMake(320, 320)];
    [self.profileImage setImageWithURL:profileUrl placeholderImage:[UIImage imageNamed:@"profile-default"]];
}

@end
