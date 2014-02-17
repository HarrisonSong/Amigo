//
//  UserModel.m
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//


#import "UserModel.h"
#import <Parse/PFObject+Subclass.h>
#import "PFObject+Extensions.h"

#pragma mark - PFObject User Class

// Class key

NSString *const kMRUserClassKey = @"User";
NSString *const kMRUserUserNameKey = @"username";
NSString *const kMRUserDisplayNameKey = @"displayName";
NSString *const kMRUserEmailKey = @"email";
NSString *const kMRUserFacebookIdKey = @"facebookId";
NSString *const kMRUserObjectIdKey = @"objectId";

@implementation UserModel

@dynamic username;
@dynamic displayName;
@dynamic email;
@dynamic facebookId;

+ (NSString *)parseClassName {
    return kMRUserClassKey;
}

- (UserModel*)initWithPFUser:(PFUser*)user{
    self = [super init];
    if(self){
        self.objectId = user.objectId;
        self.username = [user objectForKey:kMRUserUserNameKey];
        self.displayName = [user objectForKey:kMRUserDisplayNameKey];
        self.email = [user objectForKey:kMRUserEmailKey];
        self.facebookId = [user objectForKey:kMRUserFacebookIdKey];
    }
    return self;
}

@end
