//
//  FullPhotoViewController.h
//  Amigo
//
//  Created by Nur Iman Izam Othman on 24/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *
 * This is the photo viewcontroller that displays a single photo.
 *
 */
@interface FullPhotoViewController : UIViewController

// This must be set to load the photo.
@property (strong, nonatomic) NSURL *photoURL;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;

- (IBAction)backButtonPressed:(id)sender;

@end
