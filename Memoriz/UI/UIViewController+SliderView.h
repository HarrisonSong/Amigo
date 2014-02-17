//
//  UIViewController+SliderView.h
//  Memoriz
//
//  Created by Nur Iman Izam on 27/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"

/**
 * This category adds methods to the UIKit framework's `UIViewController` class. The methods in this category provide support for
 * SliderView setup.
 */
@interface UIViewController (SliderView)


/**
 * Method name: setupTopViewController
 * Description: Sets up the layer settings applies pan gesture to the view. 
 * If parent view is navigation controller, settings are applied to that instead.
 * Parameters: none
 */
- (void)setupTopViewController;

/**
 * Method name: removeGestures
 * Description: Removes gestures from topView.
 * Parameters: none
 */
- (void)removeGestures;

@end
