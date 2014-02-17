//
//  PointsModel.m
//  Memoriz
//
//  Created by Inian Parameshwaran on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "PointModel.h"
#import <Parse/PFObject+Subclass.h>
#import "PFObject+Extensions.h"

#pragma mark - PFObject Points Class

// Class key

NSString *const kMRPointClassKey = @"PFPoints";
NSString *const kMRPointUserIdKey = @"userID";
NSString *const kMRPointFriendIdKey = @"friendID";
NSString *const kMRPointPointsKey = @"points";
NSString *const kMRPointCreateAtKey = @"createAt";

@implementation PointModel

@dynamic createdAt;
@dynamic userID;
@dynamic friendID;
@dynamic points;

+ (NSString *)parseClassName {
    return kMRPointClassKey;
}

@end
