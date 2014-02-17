//
//  AchievementModel.m
//  Amigo
//
//  Created by qiyue song on 18/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AchievementModel.h"
#import <Parse/PFObject+Subclass.h>
#import "PFObject+Extensions.h"

NSString *const kMRAchievementsClassKey = @"PFAchievements";
NSString *const kMRAchievementsAchievementNumberKey = @"achievementNumber";
NSString *const kMRAchievementsUserIDKey = @"userID";

@implementation AchievementModel

@dynamic achievementNumber;
@dynamic userID;

+(NSString *)parseClassName{
    return kMRAchievementsClassKey;
}

@end
