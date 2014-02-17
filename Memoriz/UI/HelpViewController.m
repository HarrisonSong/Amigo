//
//  HelpViewController.m
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

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
    if (!IS_IPAD()) {
        [self setupTopViewController];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setStyling];
    [self setupHelpView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMenuButton:nil];
    [self setHelpPageScroll:nil];
    [self setHelpPageControl:nil];
    [super viewDidUnload];
}

#pragma mark - Button Actions

- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    NSInteger currentPage = offset.x / self.helpPageScroll.frame.size.width;
    self.helpPageControl.currentPage = currentPage;
}

#pragma mark - Helper Functions

- (void)setStyling {
    if (IS_IPAD()) {
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        [self.menuButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
}

- (void)setupHelpView {
    self.helpPageScroll.delegate = self;
    UIImage *bgImage = [UIImage imageNamed:@"help_bg"];
    self.helpPageScroll.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
    UIImageView *help1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help1"]];
    CGFloat width = help1.frame.size.width;
    CGFloat height = help1.frame.size.height;
    UIImageView *help2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help2"]];
    CGRect frame2 = CGRectMake(width, 0, width, height);
    help2.frame = frame2;
    
    UIImageView *help3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help3"]];
    CGRect frame3 = CGRectMake(width * 2, 0, width, height);
    help3.frame = frame3;
    
    CGSize contentSize = CGSizeMake(width * 3, height);
    
    self.helpPageScroll.contentSize = contentSize;
    [self.helpPageScroll addSubview:help1];
    [self.helpPageScroll addSubview:help2];
    [self.helpPageScroll addSubview:help3];
    
    self.helpPageControl.currentPage = 0;
    self.helpPageControl.numberOfPages = 3;
}

@end
