//
//  CommentsModel.m
//  Memoriz
//
//  Created by qiyue song on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CommentsModel.h"
#import <Parse/PFObject+Subclass.h>
#import "PFObject+Extensions.h"

NSString *const kMRCommentsClassKey = @"PFComments";
NSString *const kMRCommentsUserKey = @"commenterUserID";
NSString *const KMRCommentsContentKey = @"content";
NSString *const kMRCommentsTargetKey = @"targetID";

@implementation CommentsModel

@dynamic commenterUserID;
@dynamic targetID;
@dynamic content;

+(NSString *)parseClassName{
    return kMRCommentsClassKey;
}

@end
