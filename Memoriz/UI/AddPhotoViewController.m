//
//  AddPhotoViewController.m
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AddPhotoViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "UIImageView+AFNetworking.h"
#import "UserController.h"
#import "FriendsController.h"
#import "TimelinePostController.h"

@interface AddPhotoViewController ()

@property (strong, nonatomic) NSArray *friendsArray;
@property (strong, nonatomic) NSMutableArray *friendsActive;

@end

@implementation AddPhotoViewController

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
    [self setDefaultFriends];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCancelButton:nil];
    [self setPostImageButton:nil];
    [self setFacebookButton:nil];
    [self setComposerImageView:nil];
    [self setUploadingImageView:nil];
    [self setFriendButtons:nil];
    [self setFriendImageViews:nil];
    [self setUploadingImageButton:nil];
    [super viewDidUnload];
}

#pragma mark - Button Actions

- (IBAction)uploadingImageButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photo Source"
                                                             delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Photo Library", @"Cancel", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
}

- (IBAction)friendButtonsPressed:(UIButton*)button {
    if ([[self.friendsActive objectAtIndex:button.tag] boolValue]) {
        [self setFriendAtIndex:button.tag active:NO];
    } else {
        [self setFriendAtIndex:button.tag active:YES];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)facebookButtonPressed:(id)sender {
    if (sendToFacebook) {
        [self.facebookButton setAlpha:0.3];
        sendToFacebook = NO;
    } else {
        [self.facebookButton setAlpha:1.0];
        sendToFacebook = YES;
    }
}

- (IBAction)postImageButtonPressed:(id)sender {
    
    if (self.uploadingImageView.image == nil) {
        [SVProgressHUD showErrorWithStatus:@"Choose or take a picture first."];
        return;
    }
    
    NSArray *postFriends = [self getSelectedFriends];
    
    // Check if no friends selected
    if ([postFriends count] == 0) {
        [SVProgressHUD showErrorWithStatus:@"Choose at least one friend below."];
        return;
    }
    
    // Convert the image to JPEG data.
    NSData *imageData = UIImageJPEGRepresentation(self.uploadingImageView.image, 1.0);
    
    [SVProgressHUD showWithStatus:@"Uploading Photo..." maskType:SVProgressHUDMaskTypeGradient];
    
    for (UserModel* friend in postFriends) {
        [TimelinePostController uploadImage:imageData Completion:^(BOOL success, NSString *photoPath) {
            if (success) {
                [self uploadDidSuccess:photoPath ToFriend:friend];
            } else {
                [self uploadDidFail];
            }
        }];
    }
    
    if (sendToFacebook) {
        [FBRequestConnection startForUploadPhoto:self.uploadingImageView.image completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (error)
                DDLogError(@"%@, %@: %@",THIS_FILE,THIS_METHOD,[error localizedDescription]);
        }];
    }
}

#pragma mark - UIActionSheet Delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self TakePhotoWithCamera];
    } else if (buttonIndex == 1) {
        [self SelectPhotoFromLibrary];
    }
}

-(void) TakePhotoWithCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        [SVProgressHUD showErrorWithStatus:@"No camera available."];
    }
}

-(void) SelectPhotoFromLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        
        if (IS_IPAD()) {
            self.popOverController = [[UIPopoverController alloc]
                                      initWithContentViewController:imagePicker];
            
            //popOver.delegate = self;
            
            [self.popOverController
             presentPopoverFromRect:CGRectMake(self.uploadingImageView.center.x,self.uploadingImageView.center.y,1,1)  inView:self.view
             permittedArrowDirections:UIPopoverArrowDirectionUp
             animated:YES];
            
        } else {
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"Unable to access library."];
    }
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get the selected image.
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.uploadingImageView setImage:selectedImage];
    
    [picker dismissModalViewControllerAnimated:YES];
    if (IS_IPAD()){
        [self.popOverController dismissPopoverAnimated:YES];
    }
}

// upload failed
-(void)uploadDidFail
{
    [SVProgressHUD showErrorWithStatus:@"Image upload failed."];
}

// upload successful with file path response
-(void)uploadDidSuccess:(NSString*)filePath ToFriend:(UserModel*)friend
{
    
    PhotoModel *photo = [[PhotoModel alloc] init];
    photo.photoPath = filePath;
    photo.postType = kPhotoPost;
    
    [[TimelinePostController sharedInstance] postPhoto:photo ToFriend:friend complete:^(BOOL success) {
        
        if (!success) {
            [SVProgressHUD showErrorWithStatus:@"Error adding photo."];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"Photo Posted!"];
            [self.delegate composeViewController:self didCompose:photo];
            [self dismissModalViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Helper Methods 

- (void)setStyling {
    [self.cancelButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.postImageButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    NSURL *profileUrl = [Constants facebookProfileImageURLWithId:[[[UserController sharedInstance] fetchCurrentUser] objectForKey:@"facebookId"] andCGSize:CGSizeMake(80, 80)];
    [self.composerImageView setImageWithURL:profileUrl placeholderImage:[UIImage imageNamed:@"profile-default"]];
    
    [self.composerImageView.layer setCornerRadius:5.0f];
    [self.composerImageView.layer setMasksToBounds:YES];
    
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

- (NSArray*)getSelectedFriends {
    // Create array of friends to post to
    NSMutableArray *postFriends = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.friendsArray.count;i++) {
        if ([[self.friendsActive objectAtIndex:i] boolValue]) {
            [postFriends addObject:[self.friendsArray objectAtIndex:i]];
        }
    }
    
    return postFriends;
}

@end
