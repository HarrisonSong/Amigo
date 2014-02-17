//
//  AchievementController.h
//  Amigo
//
//  Created by qiyue song on 18/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AchievementModel.h"

extern NSString *const kAchievementExistenceKey;

typedef enum {
    kFirstPostAchievement,
    kFirstPhotoAchievement,
    kFirstPromiseAchievement,
    kFulfillFirstPromiseAchievement,
    k200PointsAchievement,
    k1000PointsAchievement,
    k5FriendsAchievement,
    k5Friends200PointsAchievement,
    k5Friends1000PointsAchievement,
    kHavePromiseFor5FriendsAchievement,
    kFulfillPromiseFor5FriendsAchievement
} AchievementType;

@interface AchievementController : NSObject{
    dispatch_queue_t achievementQueue;
}

@property(nonatomic,strong) NSArray *achievementsList;

// Singleton
+ (AchievementController *)sharedInstance;

/*
 * Method Name: getAchievementsForUser
 * Description: retrieve the achievements list for the specific Amigo user.
 * Parameter: userID of the specific Amigo user.
 * Parameter: callBack function to return the achievements list of the specific Amigo user.
 */
- (void)getAchievementsForUser:(NSString *)userID withCompletionHandler:(void(^)(NSArray * achievements,NSError * error))completion;

/*
 * Method Name: addAchievementForUser
 * Description: add the specific achievement to the specific Amigo user.
 * Parameter: userID of the specific Amigo user.
 * Parameter: achievementNumber of the specific achievement.
 * Parameter: callBack function to indicate if achievement has been added successfully or not.
 */
- (void)addAchievementForUser:(NSString *)userID achievementsNumber:(NSNumber *)achievement withCompletionHandler:(void(^)(NSError * error))completion;

/*
 * Method Name: checkAchievementForUser
 * Description: check if the specific user satisfies any achievement and update his/her achievements list.
 * Parameter: userID of the specific user.
 * Parameter: callBack function to indicate if checking and updating have been successfully or not.
 */
- (void)checkAchievementForUser:(NSString *)userID withCompletionHandler:(void(^)(NSError * error))completion;
@end
