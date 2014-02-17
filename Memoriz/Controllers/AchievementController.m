//
//  AchievementController.m
//  Amigo
//
//  Created by qiyue song on 18/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AchievementController.h"
#import "ServerController.h"
#import "PointsController.h"
#import "PromiseModel.h"
#import "PostModel.h"

NSString *const kAchievementExistenceKey = @"achievement exists";

@implementation AchievementController

+ (id)sharedInstance
{
    static AchievementController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[AchievementController alloc] init];
        
        //initial the achievements List
        __sharedInstance.achievementsList = @[
        @{@"id":[NSNumber numberWithInt:kFirstPostAchievement],@"title":@"First Post",@"badgeImage":@"badge_firstpost.png"},
        @{@"id":[NSNumber numberWithInt:kFirstPhotoAchievement],@"title":@"First Photo",@"badgeImage":@"badge_firstphoto.png"},
        @{@"id":[NSNumber numberWithInt:kFirstPromiseAchievement],@"title":@"fulfill first promise",@"badgeImage":@"badge_firstpromise.png"},
        @{@"id":[NSNumber numberWithInt:kFulfillFirstPromiseAchievement],@"title":@"fulfill the first promise",@"badgeImage":@"badge_fulfilfirstpromise.png"},
        @{@"id":[NSNumber numberWithInt:k200PointsAchievement],@"title":@"200 points",@"badgeImage":@"badge_200points.png"},
        @{@"id":[NSNumber numberWithInt:k1000PointsAchievement],@"title":@"1000 points",@"badgeImage":@"badge_1000points.png"},
        @{@"id":[NSNumber numberWithInt:k5FriendsAchievement],@"title":@"own 5 friends",@"badgeImage":@"badge_5friends.png"},
        @{@"id":[NSNumber numberWithInt:k5Friends200PointsAchievement],@"title":@"5 friends with all 200+ points",@"badgeImage":@"badge_5friends200+.png"},
        @{@"id":[NSNumber numberWithInt:k5Friends1000PointsAchievement],@"title":@"5 friends with all 1000+ points",@"badgeImage":@"badge_5friends1000+.png"},
        @{@"id":[NSNumber numberWithInt:kHavePromiseFor5FriendsAchievement],@"title":@"have at least one promise for all 5 friends",@"badgeImage":@"badge_1promisefor5.png"},
        @{@"id":[NSNumber numberWithInt:kFulfillPromiseFor5FriendsAchievement],@"title":@"fulfill at least one promise for all 5 friends",@"badgeImage":@"badge_fulfill5friends.png"},
        ];
    });
    
    return __sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        achievementQueue = dispatch_queue_create("sg.edu.nus.Amigo.achievements",NULL);
    }
    return self;
}

- (void)getAchievementsForUser:(NSString *)userID withCompletionHandler:(void(^)(NSArray * achievements,NSError * error))completion{
    [ServerController queryWithClassName:kMRAchievementsClassKey andConditions:@{kMRAchievementsUserIDKey:userID} andCachePolicy:NO WithCompletionHandler:^(NSArray *results, NSError *error) {
        if(!error){
            NSMutableArray *outputArray = [[NSMutableArray alloc] init];
            for (AchievementModel * achievement in results){
                [outputArray addObject:[self.achievementsList objectAtIndex:[achievement.achievementNumber intValue]]];
            }
            completion(outputArray,nil);
        }else{
            completion(nil,error);
        }
    }];
}

- (void)addAchievementForUser:(NSString *)userID achievementsNumber:(NSNumber *)achievement withCompletionHandler:(void(^)(NSError * error))completion{
    AchievementModel * newAchievement = [[AchievementModel alloc] init];
    newAchievement.userID = userID;
    newAchievement.achievementNumber = achievement;
    [newAchievement saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            completion(nil);
        }else{
            completion(error);
        }
    }];
}

- (void)checkAchievementForUser:(NSString *)userID withCompletionHandler:(void(^)(NSError * error))completion{
    PFQuery * achievementsQuery = [PFQuery queryWithClassName:kMRAchievementsClassKey];
    [achievementsQuery whereKey:kMRAchievementsUserIDKey equalTo:userID];
    
    PFQuery * messageQuery = [PFQuery queryWithClassName:kMRPostMessageClassKey];
    [messageQuery whereKey:kMRPostCreatorUserIDKey equalTo:userID];
    
    PFQuery * photoQuery = [PFQuery queryWithClassName:kMRPostPhotoClassKey];
    [messageQuery whereKey:kMRPostCreatorUserIDKey equalTo:userID];
    
    PFQuery * promiseQuery = [PFQuery queryWithClassName:kMRPostPromiseClassKey];
    [messageQuery whereKey:kMRPostCreatorUserIDKey equalTo:userID];
    
    PFQuery * pointQuery = [PFQuery queryWithClassName:kMRPointClassKey];
    [messageQuery whereKey:kMRPostCreatorUserIDKey equalTo:userID];
    
    PFQuery * fulfillPromiseQuery = [PFQuery queryWithClassName:kMRPostPromiseClassKey];
    [fulfillPromiseQuery whereKey:kMRPostCreatorUserIDKey equalTo:userID];
    [fulfillPromiseQuery whereKey:kMRPromisefulfillmentKey equalTo:[NSNumber numberWithInt:1]];
    
    //dispatch the checking tasks on the queue to run them in another thread asynchronously.
    dispatch_async(achievementQueue, ^{
        NSError *error = nil;
        
        NSArray *achievementArray = [achievementsQuery findObjects:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
            return;
        }
        
        NSArray *messageArray = [messageQuery findObjects:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
            return;
        }
        
        NSArray *photoArray = [photoQuery findObjects:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
            return;
        }
        
        NSArray *promiseArray = [promiseQuery findObjects:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
            return;
        }
        
        NSArray *pointArray = [pointQuery findObjects:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
            return;
        }
        
        NSArray * fulfillmentArray = [fulfillPromiseQuery findObjects:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
            return;
        }
        
        //get the achievements list containing the achievements the current user has achieved.
        NSMutableArray * achievementNumbers = [[NSMutableArray alloc] init];
        for (AchievementModel * achievement in achievementArray){
            [achievementNumbers addObject:achievement.achievementNumber];
        }
        
        //after query tasks finish, start checking.
        
        //check for the first achievements
        if(![achievementNumbers containsObject:[NSNumber numberWithInt:kFirstPostAchievement]]){
            if(messageArray.count > 0){
                AchievementModel * firstPostAchievement = [[AchievementModel alloc] init];
                firstPostAchievement.userID = userID;
                firstPostAchievement.achievementNumber = [NSNumber numberWithInt:kFirstPostAchievement];
                [firstPostAchievement save];
            }
        }
        
        //check for the second achievements
        if(![achievementNumbers containsObject:[NSNumber numberWithInt:kFirstPhotoAchievement]]){
            if(photoArray.count > 0){
                AchievementModel * firstPhotoAchievement = [[AchievementModel alloc] init];
                firstPhotoAchievement.userID = userID;
                firstPhotoAchievement.achievementNumber = [NSNumber numberWithInt:kFirstPhotoAchievement];
                [firstPhotoAchievement save];
            }
        }
        
        //check for the third achievements
        if(![achievementNumbers containsObject:[NSNumber numberWithInt:kFirstPromiseAchievement]]){
            if(promiseArray.count > 0){
                AchievementModel * firstPromiseAchievement = [[AchievementModel alloc] init];
                firstPromiseAchievement.userID = userID;
                firstPromiseAchievement.achievementNumber = [NSNumber numberWithInt:kFirstPromiseAchievement];
                [firstPromiseAchievement save];
            }
        }
        
        //check for the fourth achievements
        if([achievementNumbers containsObject:[NSNumber numberWithInt:kFirstPromiseAchievement]]){
            if(![achievementNumbers containsObject:[NSNumber numberWithInt:kFulfillFirstPromiseAchievement]]){
                if(fulfillmentArray.count>0){
                    AchievementModel * firstFulfillment = [[AchievementModel alloc] init];
                    firstFulfillment.userID = userID;
                    firstFulfillment.achievementNumber = [NSNumber numberWithInt:kFirstPromiseAchievement];
                    [firstFulfillment save];
                }
            }
        }
        
        if(![achievementNumbers containsObject:[NSNumber numberWithInt:k200PointsAchievement]]){
            
            //check for the fifth achievements
            for(PointModel * point in pointArray){
                if(point.points >= 200){
                    AchievementModel * point200Achievemnt = [[AchievementModel alloc] init];
                    point200Achievemnt.userID = userID;
                    point200Achievemnt.achievementNumber = [NSNumber numberWithInt:k200PointsAchievement];
                    [point200Achievemnt save];
                    break;
                }
            }
        }else if(![achievementNumbers containsObject:[NSNumber numberWithInt:k1000PointsAchievement]]){
            
            //check for the sixth achievements
            for(PointModel * point in pointArray){
                if(point.points >= 1000){
                    AchievementModel * point1000Achievemnt = [[AchievementModel alloc] init];
                    point1000Achievemnt.userID = userID;
                    point1000Achievemnt.achievementNumber = [NSNumber numberWithInt:k1000PointsAchievement];
                    [point1000Achievemnt save];
                    break;
                }
            }
        }
        
        if(![achievementNumbers containsObject:[NSNumber numberWithInt:k5FriendsAchievement]]){
            
            //check for the seventh achievements
            if(pointArray.count == 5){
                AchievementModel * friendsAchievement = [[AchievementModel alloc] init];
                friendsAchievement.userID = userID;
                friendsAchievement.achievementNumber = [NSNumber numberWithInt:k5FriendsAchievement];
                [friendsAchievement save];
            }
        }else if(![achievementNumbers containsObject:[NSNumber numberWithInt:k5Friends200PointsAchievement]]){
            
            //check for the eighth achievements
            bool proceed = true;
            for(PointModel * point in pointArray){
                if(point.points < 200){
                    proceed = false;
                    break;
                }
            }
            if(proceed){
                AchievementModel * friends200PointsAchievement = [[AchievementModel alloc] init];
                friends200PointsAchievement.userID = userID;
                friends200PointsAchievement.achievementNumber = [NSNumber numberWithInt:k5Friends200PointsAchievement];
                [friends200PointsAchievement save];
            }
        }else if(![achievementNumbers containsObject:[NSNumber numberWithInt:k5Friends1000PointsAchievement]]){
            
            //check for the ninth achievements
            bool proceed = true;
            for(PointModel * point in pointArray){
                if(point.points < 1000){
                    proceed = false;
                    break;
                }
            }
            if(proceed){
                AchievementModel * friends200PointsAchievement = [[AchievementModel alloc] init];
                friends200PointsAchievement.userID = userID;
                friends200PointsAchievement.achievementNumber = [NSNumber numberWithInt:k5Friends1000PointsAchievement];
                [friends200PointsAchievement save];
            }
        }
        
        if([achievementNumbers containsObject:[NSNumber numberWithInt:k5FriendsAchievement]]){
            if(![achievementNumbers containsObject:[NSNumber numberWithInt:kHavePromiseFor5FriendsAchievement]]){
                //check for the tenth achievement
                NSMutableDictionary * friends = [[NSMutableDictionary alloc] init];
                for(PromiseModel * promise in promiseArray){
                    [friends setValue:kAchievementExistenceKey forKey:promise.objectId];
                }
                if(friends.count == 5){
                    AchievementModel * friendsHavePromiseAchievement = [[AchievementModel alloc] init];
                    friendsHavePromiseAchievement.userID = userID;
                    friendsHavePromiseAchievement.achievementNumber = [NSNumber numberWithInt:kHavePromiseFor5FriendsAchievement];
                    [friendsHavePromiseAchievement save];
                }
            }else if(![achievementNumbers containsObject:[NSNumber numberWithInt:kFulfillPromiseFor5FriendsAchievement]]){
                
                //check for the eleventh achievement
                NSMutableDictionary * friends = [[NSMutableDictionary alloc] init];
                for(PromiseModel * promise in fulfillmentArray){
                    [friends setValue:kAchievementExistenceKey forKey:promise.objectId];
                }
                if(friends.count == 5){
                    AchievementModel * friendsHavePromiseAchievement = [[AchievementModel alloc] init];
                    friendsHavePromiseAchievement.userID = userID;
                    friendsHavePromiseAchievement.achievementNumber = [NSNumber numberWithInt:kFulfillPromiseFor5FriendsAchievement];
                    [friendsHavePromiseAchievement save];
                }
            }
        }
        completion(nil);
    });
}

@end
