//
//  EnableKeyboardHide.m
//  Amigo
//
//  Created by Nur Iman Izam on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "EnableKeyboardHide.h"

@implementation UIViewControllerKeyboardHide
- (BOOL) disablesAutomaticKeyboardDismissal {
    return NO;
}
@end

@implementation UITableViewControllerKeyboardHide
- (BOOL) disablesAutomaticKeyboardDismissal {
    return NO;
}
@end

@implementation UINavigationController(EnableKeyboardHide)
- (BOOL) disablesAutomaticKeyboardDismissal {
    return NO;
}
@end