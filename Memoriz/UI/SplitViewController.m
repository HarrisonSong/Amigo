//
//  SplitViewController.m
//  Amigo
//
//  Created by Nur Iman Izam on 20/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SplitViewController.h"
#import "FriendsViewController.h"

@interface SplitViewController ()

@end

@implementation SplitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISplitViewController Delegate

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    
    // Displays Friends Menu Permanently
    return NO;
}

@end
