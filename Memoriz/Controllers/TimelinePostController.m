//
//  TimelinePostController.m
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TimelinePostController.h"
#import "PointsController.h"
#import "ServerController.h"
#import "UserController.h"
#import "PromiseController.h"
#import "FriendsController.h"
#import "AchievementController.h"

#define RECENT_ACTIVITY_LIMIT 20

@interface TimelinePostController()

@end

@implementation TimelinePostController

+ (id)sharedInstance
{
    static TimelinePostController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[TimelinePostController alloc] init];
    });
    
    return __sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        timelineQueue = dispatch_queue_create("sg.edu.nus.Amigo.timeline",NULL);
    }
    return self;
}

- (void)dealloc {
    dispatch_release(timelineQueue);
}

- (void)getTimelinePostsWithUserID:(NSString*)friendId withCompletion:(PFArrayResultBlock)block;
{
    
    NSString *currentUserId = [[UserController sharedInstance] fetchCurrentUser].objectId;
    
    NSString *timelineCacheKey = [NSString stringWithFormat:@"timeline%@%@",currentUserId,friendId];
    if ([[EGOCache globalCache] hasCacheForKey:timelineCacheKey]) {
        block((NSArray*)[[EGOCache globalCache] objectForKey:timelineCacheKey],nil);
    }
    
    PFQuery *messageQuery = [PFQuery queryWithClassName:kMRPostMessageClassKey];
    [messageQuery whereKey:kMRPostCreatorUserIDKey equalTo:currentUserId];
    [messageQuery whereKey:kMRPostToUserIDKey equalTo:friendId];
    
    PFQuery *friendMessageQuery = [PFQuery queryWithClassName:kMRPostMessageClassKey];
    [friendMessageQuery whereKey:kMRPostCreatorUserIDKey equalTo:friendId];
    [friendMessageQuery whereKey:kMRPostToUserIDKey equalTo:currentUserId];
    
    messageQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:messageQuery, friendMessageQuery, nil]];
    
    PFQuery *photoQuery = [PFQuery queryWithClassName:kMRPostPhotoClassKey];
    [photoQuery whereKey:kMRPostCreatorUserIDKey equalTo:currentUserId];
    [photoQuery whereKey:kMRPostToUserIDKey equalTo:friendId];
    
    PFQuery *friendPhotoQuery = [PFQuery queryWithClassName:kMRPostPhotoClassKey];
    [friendPhotoQuery whereKey:kMRPostCreatorUserIDKey equalTo:friendId];
    [friendPhotoQuery whereKey:kMRPostToUserIDKey equalTo:currentUserId];
    
    photoQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:photoQuery, friendPhotoQuery, nil]];
    
    PFQuery *promiseQuery = [PFQuery queryWithClassName:kMRPostPromiseClassKey];
    [promiseQuery whereKey:kMRPostCreatorUserIDKey equalTo:currentUserId];
    [promiseQuery whereKey:kMRPostToUserIDKey equalTo:friendId];
    
    PFQuery *friendPromiseQuery = [PFQuery queryWithClassName:kMRPostPromiseClassKey];
    [friendPromiseQuery whereKey:kMRPostCreatorUserIDKey equalTo:friendId];
    [friendPromiseQuery whereKey:kMRPostToUserIDKey equalTo:currentUserId];
    
    promiseQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:promiseQuery, friendPromiseQuery, nil]];
    
    PFQuery *eventQuery = [PFQuery queryWithClassName:kMRPostEventClassKey];
    
    [eventQuery whereKey:kMRPostCreatorUserIDKey equalTo:currentUserId];
    [eventQuery whereKey:kMRPostToUserIDKey equalTo:friendId];
    
    PFQuery *friendEventQuery = [PFQuery queryWithClassName:kMRPostEventClassKey];
    [friendEventQuery whereKey:kMRPostCreatorUserIDKey equalTo:friendId];
    [friendEventQuery whereKey:kMRPostToUserIDKey equalTo:currentUserId];
    
    eventQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:eventQuery, friendEventQuery, nil]];
    
    [self asyncLoadMessage:messageQuery Photo:photoQuery Promise:promiseQuery Event:eventQuery withCompletion:^(NSArray *objects, NSError *error) {
        [[UserController sharedInstance] getFacebookPhotosWithFriend:friendId withCompletionHandler:^(NSArray *photos, NSError *error) {
            NSMutableArray *results = [NSMutableArray arrayWithArray:photos];
            [results addObjectsFromArray:objects];
            block(results, error);
            [[EGOCache globalCache] setObject:results forKey:timelineCacheKey];
        }];
    }];
    
}

- (void) asyncLoadMessage:(PFQuery*)messageQuery
                    Photo:(PFQuery*)photoQuery
                  Promise:(PFQuery*)promiseQuery
                     Event:(PFQuery*)eventQuery
           withCompletion:(PFArrayResultBlock)block;
{
    dispatch_async(timelineQueue, ^{
        
        NSError *error = nil;
        NSArray *messageArray = [messageQuery findObjects:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(nil,error);
            });
            return;
        }
        
        NSArray *photoArray = [photoQuery findObjects:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(nil,error);
            });
            return;
        }
        
        NSArray *promiseArray = [promiseQuery findObjects:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(nil,error);
            });
            return;
        }
        
        NSArray *eventArray = [eventQuery findObjects:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(nil,error);
            });
            return;
        }
        
        NSMutableArray *outputArray = [[NSMutableArray alloc] init];
        [outputArray addObjectsFromArray:messageArray];
        [outputArray addObjectsFromArray:photoArray];
        [outputArray addObjectsFromArray:promiseArray];
        [outputArray addObjectsFromArray:eventArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(outputArray,nil);
        });
    });
}

- (void)postMessage:(MessageModel*)message ToFriend:(UserModel*)user complete:(void(^)(BOOL success))callback;
{
    PFUser * currentUser = [[UserController sharedInstance] fetchCurrentUser];
    NSString *currentUserId = currentUser.objectId;
    message.creatorUserID = currentUserId;
    message.postToUserID = user.objectId;
    message.commentCount = 0;
    
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"succeeded:%@, error:%@", (succeeded?@"YES":@"NO"), error);
        callback(succeeded);
        
        [[PointsController sharedInstance] updatePointsWithUserID:message.postToUserID forEvent:kTimeLinePostEvent];
        [[AchievementController sharedInstance] checkAchievementForUser:currentUserId withCompletionHandler:^(NSError *error) {
            
        }];
        NSArray * users = [NSArray arrayWithObject:user];
        NSString *alert = [NSString stringWithFormat:@"%@ has posted on your timeline", [currentUser objectForKey:kMRUserDisplayNameKey]];
        NSDictionary *pushData = @{@"badge":@"Increment", @"friendID": [user objectId], @"alert": alert};
        [[ServerController sharedInstance] sendPushNotificationToUsers:users withData:pushData];

    }];
}

- (void)postPhoto:(PhotoModel*)photo ToFriend:(UserModel*)user complete:(void(^)(BOOL success))callback
{
    PFUser * currentUser = [[UserController sharedInstance] fetchCurrentUser];
    NSString *currentUserId = currentUser.objectId;
    photo.creatorUserID = currentUserId;
    photo.postToUserID = user.objectId;
    photo.commentCount = 0;
    
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"succeeded:%@, error:%@", (succeeded?@"YES":@"NO"), error);
        callback(succeeded);
        
        [[PointsController sharedInstance] updatePointsWithUserID:photo.postToUserID forEvent:kTimeLinePhotoEvent];
        [[AchievementController sharedInstance] checkAchievementForUser:currentUserId withCompletionHandler:^(NSError *error) {
            
        }];
        NSArray * users = [NSArray arrayWithObject:user];
        NSString *alert = [NSString stringWithFormat:@"%@ has shared a photo on your timeline", [currentUser objectForKey:kMRUserDisplayNameKey]];
        NSDictionary *pushData = @{@"badge":@"Increment", @"friendID": [user objectId], @"alert": alert};
        [[ServerController sharedInstance] sendPushNotificationToUsers:users withData:pushData];
    }];
}

- (void)postPromise:(PromiseModel*)promise ToFriend:(UserModel*)user complete:(void(^)(BOOL success))callback
{
    PFUser * currentUser = [[UserController sharedInstance] fetchCurrentUser];
    NSString *currentUserId = currentUser.objectId;
    promise.creatorUserID = currentUserId;
    promise.postToUserID = user.objectId;
    promise.fulfillment = [NSNumber numberWithInt:createdButNotFulfillYet];
    promise.commentCount = 0;
    
    [promise saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"succeeded:%@, error:%@", (succeeded?@"YES":@"NO"), error);
        callback(succeeded);
        
        [[PointsController sharedInstance] updatePointsWithUserID:promise.postToUserID forEvent:kPromiseEvent];
        [[AchievementController sharedInstance] checkAchievementForUser:currentUserId withCompletionHandler:^(NSError *error) {
            
        }];
        NSArray * users = [NSArray arrayWithObject:user];
        NSString *alert = [NSString stringWithFormat:@"%@ has promised you something!", [currentUser objectForKey:kMRUserDisplayNameKey]];
        NSDictionary *pushData = @{@"badge":@"Increment", @"friendID": [user objectId], @"alert": alert};
        [[ServerController sharedInstance] sendPushNotificationToUsers:users withData:pushData];
    }];
    
    
    // post to facebook
    
    /*
     if ([FBSession.activeSession.permissions indexOfObject:@"create_event"] == NSNotFound) {
     // no permission
     
     [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"create_event"]
     defaultAudience:FBSessionDefaultAudienceFriends
     completionHandler:^(FBSession *session, NSError *error) {
     if (!error) {
     [self postPromiseToFacebookEvent:promise ToFriend:user];
     NSArray * users = [NSArray arrayWithObject:user];
     [[ServerController sharedInstance] sendPushNotificationToUsers:users WithMessage:[NSString stringWithFormat:@"%@ post a new promise.", [currentUser objectForKey:@"displayName"]]];
     }
     }];
     } else {
     // publish
     [self postPromiseToFacebookEvent:promise ToFriend:user];
     NSArray * users = [NSArray arrayWithObject:user];
     [[ServerController sharedInstance] sendPushNotificationToUsers:users WithMessage:[NSString stringWithFormat:@"%@ post a new promise.", [currentUser objectForKey:@"displayName"]]];
     }
     */
}

- (void)postEvent:(EventModel*)event ToFriend:(UserModel*)user complete:(void(^)(BOOL success))callback
{
    PFUser * currentUser = [[UserController sharedInstance] fetchCurrentUser];
    NSString *currentUserId = currentUser.objectId;
    event.creatorUserID = currentUserId;
    event.postToUserID = user.objectId;
    event.commentCount = 0;
    
    if (!event.location) {
        event.location = @"";
    }
    
    if (!event.endTime) {
        event.endTime = [NSDate dateWithTimeIntervalSince1970:0];
    }
    
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"succeeded:%@, error:%@", (succeeded?@"YES":@"NO"), error);
        callback(succeeded);
        
        NSArray * users = [NSArray arrayWithObject:user];
        NSString *alert = [NSString stringWithFormat:@"%@ sent you a new event request", [currentUser objectForKey:kMRUserDisplayNameKey]];
        NSDictionary *pushData = @{@"badge":@"Increment", @"friendID": [user objectId], @"alert": alert};
        [[ServerController sharedInstance] sendPushNotificationToUsers:users withData:pushData];
    }];
}

- (void)getSignedImageURLForPath:(NSString*)imagePath Completion:(void(^)(NSURL *url, NSError *error)) completion
{
    if ([[EGOCache globalCache] hasCacheForKey:[Constants keyForPath:imagePath]]) {
        NSURL *outputURL = [NSURL URLWithString:[[EGOCache globalCache] stringForKey:[Constants keyForPath:imagePath]]];
        completion(outputURL,nil);
    } else {
        ServerController *controller = [ServerController sharedInstance];
        [controller.s3Controller getImageURLByFilePath:imagePath Completion:^(NSURL *url, NSError *error) {
            [[EGOCache globalCache] setString:[url absoluteString] forKey:[Constants keyForPath:imagePath] withTimeoutInterval:CACHE_IMAGE_TIMEOUT];
            completion(url, error);
        }];
    }
}

- (void)postPromiseToFacebookEvent:(PromiseModel*)promise ToFriend:(UserModel*)friend
{
    
    NSLog(@"post event to fb");
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZZZ"];
    NSLog(@"%@", promise.promiseDeadline);
    NSLog(@"facebook date strong format: %@", [dateFormatter stringFromDate:promise.promiseDeadline]);
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       promise.promiseContent, @"name",
                                       [dateFormatter stringFromDate:promise.promiseDeadline], @"start_time",
                                       @"FRIENDS", @"privacy_type", nil];
    
    [FBRequestConnection
     startWithGraphPath:@"me/events"
     parameters:postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         DDLogCVerbose(@"facebook event:%@, with error:%@", result, error);
     }];
    
    
}


+ (void)uploadImage:(NSData *)imageData Completion:(void(^)(BOOL success, NSString *photoPath))callback
{
    [[ServerController sharedInstance].s3Controller uploadImageToS3Bucket:imageData Completion:^(BOOL success, NSString *photoPath) {
        
        callback(success, photoPath);
    }];
}

- (void)getLatestPostsFromFriendsWithCompletion:(PFArrayResultBlock)completion {
    
    NSString *currentUserId = [[UserController sharedInstance] fetchCurrentUser].objectId;
    NSString *notificationCacheKey = [NSString stringWithFormat:@"timelineNotification%@",currentUserId];
    
    __block NSMutableArray *friendsIdArray = nil;
    
    if ([[EGOCache globalCache] hasCacheForKey:notificationCacheKey]) {
        completion((NSArray*)[[EGOCache globalCache] objectForKey:notificationCacheKey],nil);
    }
    
    [FriendsController getFriendsListWithCompletionHandler:^(NSArray *friendsArray, NSError *error) {
        
        if (friendsIdArray == nil) {
            
            friendsIdArray = [[NSMutableArray alloc] init];
            for (UserModel *friend in friendsArray) {
                [friendsIdArray addObject:friend.objectId];
            }
            
            NSLog(@"%@",friendsIdArray);
            
            PFQuery *friendMessageQuery = [PFQuery queryWithClassName:kMRPostMessageClassKey];
            [friendMessageQuery whereKey:kMRPostCreatorUserIDKey containedIn:friendsIdArray];
            [friendMessageQuery whereKey:kMRPostToUserIDKey equalTo:currentUserId];
            
            PFQuery *friendPhotoQuery = [PFQuery queryWithClassName:kMRPostPhotoClassKey];
            [friendPhotoQuery whereKey:kMRPostCreatorUserIDKey containedIn:friendsIdArray];
            [friendPhotoQuery whereKey:kMRPostToUserIDKey equalTo:currentUserId];
            
            PFQuery *friendPromiseQuery = [PFQuery queryWithClassName:kMRPostPromiseClassKey];
            [friendPromiseQuery whereKey:kMRPostCreatorUserIDKey containedIn:friendsIdArray];
            [friendPromiseQuery whereKey:kMRPostToUserIDKey equalTo:currentUserId];
            
            dispatch_async(timelineQueue, ^{
                
                NSError *error = nil;
                NSArray *messageArray = [friendMessageQuery findObjects:&error];
                
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil,error);
                    });
                    return;
                }
                
                NSArray *photoArray = [friendPhotoQuery findObjects:&error];
                
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil,error);
                    });
                    return;
                }
                
                NSArray *promiseArray = [friendPromiseQuery findObjects:&error];
                
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil,error);
                    });
                    return;
                }
                
                NSMutableArray *outputArray = [[NSMutableArray alloc] init];
                [outputArray addObjectsFromArray:messageArray];
                [outputArray addObjectsFromArray:photoArray];
                [outputArray addObjectsFromArray:promiseArray];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //[[EGOCache globalCache] setObject:outputArray forKey:timelineCacheKey];
                    [outputArray sortUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO] ] ];
                    NSArray *limitedPosts = [NSArray array];
                    if ([outputArray count] > RECENT_ACTIVITY_LIMIT) {
                        limitedPosts = [outputArray subarrayWithRange:NSMakeRange(0, RECENT_ACTIVITY_LIMIT)];
                        [[EGOCache globalCache] setObject:limitedPosts forKey:notificationCacheKey];
                        completion(limitedPosts, nil);
                    } else {
                        [[EGOCache globalCache] setObject:outputArray forKey:notificationCacheKey];
                        completion(outputArray, nil);
                    }
                    
                });
            });
            
        } // End if friendIdArray = nil
    }]; // End Friends block
    
}


- (void)getPostsNumberWithUserID:(NSString*)userID withCompletion:(void(^)(NSNumber * count,NSError * error))completion{
    
    NSString *timelinePostNumberCacheKey = [NSString stringWithFormat:@"timelinePostNumber%@",userID];
    
    if ([[EGOCache globalCache] hasCacheForKey:timelinePostNumberCacheKey]) {
        completion((NSNumber*)[[EGOCache globalCache] objectForKey:timelinePostNumberCacheKey],nil);
    }
    
    PFQuery *messageQuery = [PFQuery queryWithClassName:kMRPostMessageClassKey];
    [messageQuery whereKey:kMRPostCreatorUserIDKey equalTo:userID];
        
    PFQuery *photoQuery = [PFQuery queryWithClassName:kMRPostPhotoClassKey];
    [photoQuery whereKey:kMRPostCreatorUserIDKey equalTo:userID];
        
    PFQuery *promiseQuery = [PFQuery queryWithClassName:kMRPostPromiseClassKey];
    [promiseQuery whereKey:kMRPostCreatorUserIDKey equalTo:userID];
    
    dispatch_async(timelineQueue, ^{
        
        NSError *error = nil;
        NSArray *messageArray = [messageQuery findObjects:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil,error);
            });
            return;
        }
        
        NSArray *photoArray = [photoQuery findObjects:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil,error);
            });
            return;
        }
        
        NSArray *promiseArray = [promiseQuery findObjects:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil,error);
            });
            return;
        }
        
        int count = 0;
        count = messageArray.count + photoArray.count + promiseArray.count;
        NSNumber * number = [NSNumber numberWithInt:count];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[EGOCache globalCache] setObject:number forKey:timelinePostNumberCacheKey];
            completion(number,nil);
        });
    });

}

- (void)getTotalPointsWithUserID:(NSString *)userID withCompletion:(void(^)(int point,NSError * error))completion{
    [ServerController queryWithClassName:kMRPointClassKey andConditions:@{kMRPointUserIdKey:userID} WithCompletionHandler:^(NSArray *points, NSError *pointError) {
        if(!pointError){
            DDLogVerbose(@"%@: %@,%@",THIS_FILE,THIS_METHOD, points);
            int totalPoints = 0;
            for(PointModel * point in points){
                totalPoints = totalPoints + point.points;
            }
            completion(totalPoints,nil);
        }else{
            DDLogVerbose(@"Error: %@ %@", pointError, [pointError userInfo]);
        }
    }];
}

- (void)getFriendsNumberWithUserID:(NSString*)userID withCompletion:(void(^)(int count, NSError * error))completion{
    [ServerController queryUserWithConditions:@{@"objectId":userID} andCompletionHandler:^(NSArray *results, NSError *error) {
        if(!error){
            [ServerController queryWithClassName:kMRFriendsClassKey andConditions:@{kMRFriendsUserIDKey:results[0]} WithCompletionHandler:^(NSArray *friends, NSError *friendError) {
                if(!friendError){
                    DDLogVerbose(@"%@: %@,%@",THIS_FILE,THIS_METHOD, friends);
                    completion(friends.count,nil);
                }else{
                    DDLogVerbose(@"Error: %@ %@", friendError, [friendError userInfo]);
                    completion(0,friendError);
                }
            }];
        }else{
            DDLogVerbose(@"Error: %@ %@", error, [error userInfo]);
            completion(0,error);
        }
    }];
}

@end
