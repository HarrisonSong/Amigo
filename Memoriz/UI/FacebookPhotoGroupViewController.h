//
//  FacebookPhotoGroupViewController.h
//  Amigo
//
//  Created by Nur Iman Izam Othman on 24/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookPhotoGroupModel.h"

/**
 *
 * This is the facebook photo group viewcontroller that displays photos tagged on the same day.
 *
 */
@interface FacebookPhotoGroupViewController : UITableViewController

// This must be set to display the photos
@property (strong, nonatomic) FacebookPhotoGroupModel *facebookGroupModel;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;

- (IBAction)backButtonPressed:(id)sender;

@end
