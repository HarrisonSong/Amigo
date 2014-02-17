//
//  UserModel.h
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#pragma mark - PFObject User Class

// Class key
extern NSString *const kMRUserClassKey;
extern NSString *const kMRUserUserNameKey;
extern NSString *const kMRUserDisplayNameKey;
extern NSString *const kMRUserEmailKey;
extern NSString *const kMRUserFacebookIdKey;
extern NSString *const kMRUserObjectIdKey;

@interface UserModel : PFUser<PFSubclassing,NSCoding>

+ (NSString *)parseClassName;
- (UserModel*)initWithPFUser:(PFUser*)user;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *facebookId;

@end
