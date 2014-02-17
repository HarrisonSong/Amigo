//
//  FriendsController.h
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserController.h"
#import "InviteRequestModel.h"

extern NSString *const KMRUserFacebookIDKey;
extern NSString *const kMRFriendsClassKey;
extern NSString *const kMRFriendsFriendIDKey;
extern NSString *const kMRFriendsUserIDKey;
extern NSString *const kMRFriendsUsernameKey;

@interface FriendsController : NSObject
{
    dispatch_queue_t friendQueue;
}

// Singleton
+ (id)sharedInstance;

/*
 * Method Name: inviteFriends
 * Description: send invition requests to a list of Facebook friends
 * Parameter: array containing all the FacebookIDs of the friends who are sent invition requests.
 * Parameter: callBack function to indicate if sending requests successfully or not.
 */
+ (void)inviteFriends:(NSArray*)facebookIDArray withCompletionHandler:(void(^)(NSError *error))completion;

/*
 * Method Name: getFriendsListWithCompletionHandler
 * Description: fetch the Amigo friends list of the current user
 * Parameter: callBack function to return the information for all the Amigo friends of current user.
 */
+ (void)getFriendsListWithCompletionHandler: (void(^)(NSArray *friendsArray, NSError *error))completion;

/*
 * Method Name: getInviteRequestsWithCompletionHandler
 * Description: fetch the invition requests inviting the current user
 * Parameter: callBack function to return the information for all invition requests inviting the current user.
 */
+ (void)getInviteRequestsWithCompletionHandler:(void(^)(NSArray *requestsArray, NSError *error))completion;

/*
 * Method Name: getinvitionWithCompletionHandler
 * Description: fetch the invition requests sent by the current user 
 * Parameter: callBack function to return the information for all invition requests sent by the current user.
 */
+ (void)getinvitionWithCompletionHandler: (void(^)(NSArray *requestsArray, NSError *error))completion;

/*
 * Method Name: getInviteRequestCurrentFriendListWithCompletionHandler
 * Description: fetch FacebookIDs of all current user's Amigo friends, the Amigo users sending invition requests
 *             to the current user and the Facebook friends whom the current user sends invition requests to.
 * Parameter: callBack function to return the information for FacebookIDs of all current user's Amigo friends,
 *           the Amigo users sending invition requests to the current user and the Facebook friends whom the
 *           current user sends invition requests to.
 */
- (void)getInviteRequestCurrentFriendListWithCompletionHandler:(void(^)(NSArray *requestsArray, NSError *error))completion;

/*
 * Method Name: acceptInviteRequest
 * Description: add the specific Amigo user to the friends of current user when current user accept the invition
 *             requests.
 * Parameter: the userID of the specific Amigo user whom the current user want to add as a friend.
 * Parameter: callBack function to indicate if the specific Amigo user has been added to the friends of current user
 *            or not.
 */
+ (void)acceptInviteRequest:(NSString *)userID withCompletion:(void(^)(NSError *error))completion;

/*
 * Method Name: rejectInviteRequest
 * Description: reject the invition request from the specific Amigo user.
 * Parameter: the userID of the specific Amigo user whom the current user want to reject.
 * Parameter: callBack function to indicate if the specific Amigo invition request has been rejected or not.
 */
+ (void)rejectInviteRequest:(NSString *)userID withCompletion:(void(^)(NSError *error))completion;

/*
 * Method Name: deleteInvition
 * Description: cancel the invtion request sent by current user to the specific Facebook friend.
 * Parameter: Facebook ID of the specific Facebook friend.
 * Parameter: callBack function to indicate if the cancelation is successful or not.
 */
+ (void)deleteInvition:(NSString *)FBID withCompletion:(void(^)(NSError *error))completion;

/*
 * Method Name: unfriend
 * Description: remove the specific Amigo friend of the current user.
 * Parameter: the userID of the specific Amigo friend whom current user want to unfriend.
 */
+ (void)unfriend:(NSString *)friendID;
@end
