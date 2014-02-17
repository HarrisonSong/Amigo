//
//  ComposeViewDelegate.h
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostModel.h"
#import "CommentsModel.h"

/**
 *
 * This is a delgate protocol to get responses from composing viewcontrollers
 * that post new items
 *
 */
@protocol ComposeViewDelegate <NSObject>

@optional
- (void)composeViewController:(UIViewController*)viewController didCompose:(PostModel*)postModel;
- (void)composeViewControllerDidCancel:(UIViewController *)viewController;
- (void)composeViewController:(UIViewController*)viewController didCommentForPost:(PostModel*)postModel;
@end
