//
//  InviteRequestModel.h
//  Memoriz
//
//  Created by qiyue song on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import <Parse/Parse.h>
#import "UserModel.h"

extern NSString *const kMRRequestClassKey;
extern NSString *const KMRRequestUserIDKey;
extern NSString *const KMRRequestFBIDKey;
extern NSString *const KMRRequestObjectIDKey;

@interface InviteRequestModel : PFObject <PFSubclassing, NSCoding>

+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString *fbID;
@property (nonatomic, strong) PFUser *userID;

@end
