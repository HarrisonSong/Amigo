//
//  TimelinePostController.h
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "PhotoModel.h"
#import "MessageModel.h"
#import "PromiseModel.h"
#import "EventModel.h"

@interface TimelinePostController : NSObject {
    dispatch_queue_t timelineQueue;
}

// Singleton
+ (id)sharedInstance;

/*!
 get time line posts for the current user a certain friend
 @param: the objectID for the friend user object
 @param: return success block containing the posts
 */
- (void)getTimelinePostsWithUserID:(NSString*)friendId withCompletion:(PFArrayResultBlock)block;

/*!
 post a text message to a friend
 @param: the message model object
 @param: the friend user model object
 @param: completion callback
 */
- (void)postMessage:(MessageModel*)message ToFriend:(UserModel*)user complete:(void(^)(BOOL success))callback;

/*!
 post a photo to a friend
 @param: the photo model object
 @param: the user model object
 @param: completion callback
 */
- (void)postPhoto:(PhotoModel*)photo ToFriend:(UserModel*)user complete:(void(^)(BOOL success))callback;

/*!
 post a promise to a friend
 @param: the promise model object
 @param: the user model object
 @param: the completion callback
 */
- (void)postPromise:(PromiseModel*)promise ToFriend:(UserModel*)user complete:(void(^)(BOOL success))callback;

/*!
 post a event to a friend
 @param: the even model object
 @param: the user model object
 @param: completion callback
 */
- (void)postEvent:(EventModel*)event ToFriend:(UserModel*)user complete:(void(^)(BOOL success))callback;

/*!
 get the signed image url for a certain stored photo path on the s3 server
 @param: image path string
 @param: completion block with signed url and error object
 */
- (void)getSignedImageURLForPath:(NSString*)imagePath Completion:(void(^)(NSURL *url, NSError *error)) completion;

/*!
 upload image data to server and store photopath to parse server
 @param: the image data to be uploaded
 @param: success callback with success bool and photoPath string
 */
+ (void)uploadImage:(NSData *)imageData Completion:(void(^)(BOOL success, NSString *photoPath))callback;

/*!
 get the latest posts from all friends with a limit 20
 @param: completion block with post results
 */
- (void)getLatestPostsFromFriendsWithCompletion:(PFArrayResultBlock)completion;

/*!
 get the total post count for a certain user
 @param: the user's objectID
 @param: completion block with post count and error
 */
- (void)getPostsNumberWithUserID:(NSString*)userID withCompletion:(void(^)(NSNumber * count,NSError * error))completion;

/*!
 get the total points of a certain user
 @param: user's objectID
 @param: completion block with total points in number and error
 */
- (void)getTotalPointsWithUserID:(NSString *)userID withCompletion:(void(^)(int count,NSError * error))completion;

/*!
 get the friend count for a certain user
 @param: user's objectID
 @param: completion block with total user count and error
 */
- (void)getFriendsNumberWithUserID:(NSString*)userID withCompletion:(void(^)(int count, NSError * error))completion;

@end
