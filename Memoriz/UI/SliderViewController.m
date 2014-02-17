//
//  SliderViewController.m
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 19/2/13.
//  Copyright (c) 2013 imanism. All rights reserved.
//

#import "SliderViewController.h"

@interface SliderViewController ()

@end

@implementation SliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up Initial View
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeView"];

    // Set up Menu
    self.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
    
    // Set up Friends
    self.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsView"];

    self.anchorLeftRevealAmount = 280.0f;
    self.anchorRightRevealAmount = 280.0f;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

@end
