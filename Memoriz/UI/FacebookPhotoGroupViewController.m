//
//  FacebookPhotoGroupViewController.m
//  Amigo
//
//  Created by Nur Iman Izam Othman on 24/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FacebookPhotoGroupViewController.h"
#import "FBPhotoCell.h"
#import "UIImageView+AFNetworking.h"
#import "FacebookPhotoModel.h"
#import "FullPhotoViewController.h"

@interface FacebookPhotoGroupViewController ()

@end

@implementation FacebookPhotoGroupViewController

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
    [self addGestures];
}

- (void)viewDidUnload {
    [self setBackButton:nil];
    [super viewDidUnload];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.facebookGroupModel.facebookPhotos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FBPhotoCell";
    FBPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setStyling];
    
    FacebookPhotoModel *photoModel = [self.facebookGroupModel.facebookPhotos objectAtIndex:indexPath.row];
    [cell.mainImageView setImageWithURL:photoModel.bigPhotoURL placeholderImage:[UIImage imageNamed:@""]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    FacebookPhotoModel *photoModel = [self.facebookGroupModel.facebookPhotos objectAtIndex:indexPath.row];
    
    FullPhotoViewController *photoView = [self.storyboard instantiateViewControllerWithIdentifier:@"FullPhotoView"];
    photoView.photoURL = photoModel.bigPhotoURL;
    
    [self.navigationController pushViewController:photoView animated:YES];
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
