//
//  FullPhotoViewController.m
//  Amigo
//
//  Created by Nur Iman Izam Othman on 24/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FullPhotoViewController.h"
#import "UIImageView+AFNetworking.h"

@interface FullPhotoViewController ()

@end

@implementation FullPhotoViewController

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
    [self addGestures];
    [self.mainImageView setImageWithURL:self.photoURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackButton:nil];
    [self setMainImageView:nil];
    [super viewDidUnload];
}

#pragma mark - Button Actions

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper Functions

- (void)setStyling {
    [self.backButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}
- (void)addGestures {
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonPressed:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
}

@end
