//
//  AddPhotoViewController.h
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewDelegate.h"

/**
 *
 * This is the photo compose viewcontroller.
 *
 */
@interface AddPhotoViewController : UIViewController <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    BOOL sendToFacebook;
}

@property (weak, nonatomic) id<ComposeViewDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *defaultActiveFriends;

@property (strong, nonatomic) IBOutlet UIImageView *composerImageView;

@property (strong, nonatomic) IBOutlet UIImageView *uploadingImageView;
@property (strong, nonatomic) IBOutlet UIButton *uploadingImageButton;
@property (strong, nonatomic) UIPopoverController *popOverController;

- (IBAction)uploadingImageButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *friendButtons;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *friendImageViews;

- (IBAction)friendButtonsPressed:(UIButton*)button;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *postImageButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)postImageButtonPressed:(id)sender;
- (IBAction)facebookButtonPressed:(id)sender;


@end
