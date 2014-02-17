//
//  EventsController.h
//  Amigo
//
//  Created by Zenan on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "EventModel.h"

@interface EventsController : NSObject

+ (id)sharedInstance;

/*!
 get user's all public facebook events
 @param: completion block with error and an array of facebook public events
 */
+ (void)getUserFacebookEventsWithCompletionHandler:(void(^)(NSError *error, NSArray *events))completion;

/*!
 invite a friend to a event
 @param: friend's user model object
 @param: the event model object
 @param: completion block with error
 */
+ (void)inviteFriend:(UserModel*)friendUser ToEvent:(EventModel*)event Completion:(void(^)(NSError *error))completion;

/*!
 get the user's invited event to a certain friend
 @param: friend's user object
 @param: completion block with error and event array
 */
+ (void)getInvitedEventToFriend:(UserModel*)friendUser Completion:(void(^)(NSError *error, NSArray *result))completion;

/*!
 set current user's event status as going
 @param: the event model object
 @param: completion block with error
 */
+ (void)goingToEvent:(EventModel*)event Completion:(void(^)(NSError *error))completion;

@end
