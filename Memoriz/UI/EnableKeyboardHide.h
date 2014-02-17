//
//  EnableKeyboardHide.h
//  Amigo
//
//  Created by Nur Iman Izam on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * This is a set of categories and subclasses created to enable viewcontrollers on iPad to dismiss keyboard when
 * resignFirstResponder is called.
 */

@interface UIViewControllerKeyboardHide : UIViewController
- (BOOL) disablesAutomaticKeyboardDismissal;
@end

@interface UITableViewControllerKeyboardHide : UITableViewController
- (BOOL) disablesAutomaticKeyboardDismissal;
@end

@interface UINavigationController(EnableKeyboardHide)
- (BOOL) disablesAutomaticKeyboardDismissal;
@end