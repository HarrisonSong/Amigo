//
//  AchievementModel.h
//  Amigo
//
//  Created by qiyue song on 18/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Parse/Parse.h>

extern NSString *const kMRAchievementsClassKey;
extern NSString *const kMRAchievementsAchievementNumberKey;
extern NSString *const kMRAchievementsUserIDKey;

@interface AchievementModel : PFObject <PFSubclassing, NSCoding>

+(NSString *)parseClassName;
@property (nonatomic, strong) NSNumber *achievementNumber;
@property (nonatomic, strong) NSString *userID;

@end
