//
//  HelpViewController.h
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+SliderView.h"

/**
 *
 * This is the help viewcontroller.
 *
 */
@interface HelpViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@property (strong, nonatomic) IBOutlet UIScrollView *helpPageScroll;
@property (strong, nonatomic) IBOutlet UIPageControl *helpPageControl;

- (IBAction)menuButtonPressed:(id)sender;

@end
