//
//  UIViewController+SliderView.m
//  Memoriz
//
//  Created by Nur Iman Izam on 27/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "UIViewController+SliderView.h"

@implementation UIViewController (SliderView)

/**
 * Method name: setupTopViewController
 * Description: Sets up the layer settings applies pan gesture to the view.
 * If parent view is navigation controller, pan is applied to that instead.
 * Parameters: none
 */
- (void)setupTopViewController {
    
    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        self.navigationController.view.layer.shadowOpacity = 0.75f;
        self.navigationController.view.layer.shadowRadius = 10.0f;
        self.navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    } else {
        self.view.layer.shadowOpacity = 0.75f;
        self.view.layer.shadowRadius = 10.0f;
        self.view.layer.shadowColor = [UIColor blackColor].CGColor;
        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
}

/**
 * Method name: removeGestures
 * Description: Removes gestures from topView.
 * Parameters: none
 */
- (void)removeGestures {
    
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        for (UIGestureRecognizer *gestureRecognizer in self.navigationController.view.gestureRecognizers) {
            [self.navigationController.view removeGestureRecognizer:gestureRecognizer];
        }
    } else {
        for (UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers) {
            [self.view removeGestureRecognizer:gestureRecognizer];
        }
    }
    
}

@end
