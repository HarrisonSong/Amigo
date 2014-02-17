//
//  InviteRequestModel.m
//  Memoriz
//
//  Created by qiyue song on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "InviteRequestModel.h"
#import "PFObject+Extensions.h"

NSString *const kMRRequestClassKey = @"PFPendingRequests";
NSString *const KMRRequestUserIDKey = @"userID";
NSString *const KMRRequestFBIDKey = @"fbID";
NSString *const KMRRequestObjectIDKey = @"objectId";

@implementation InviteRequestModel

@dynamic fbID;
@dynamic userID;

+(NSString *)parseClassName{
    return kMRRequestClassKey;
}

@end
