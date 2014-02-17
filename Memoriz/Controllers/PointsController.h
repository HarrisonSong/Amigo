//
//  PointsController.h
//  Memoriz
//
//  Created by Inian Parameshwaran on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PointModel.h"
#import "PointsConfig.h"

// Notifications
extern NSString *const PointsControllerDidUpdatePoints;

@interface PointsController : NSObject

// Singleton
+ (PointsController *)sharedInstance;

/*
 * Description: updates the points of the current user with a friend based on an event
 * Parameter: The userId of the friend
 * Parameter: The event based on which the points will be updated
 */
- (void) updatePointsWithUserID:(NSString *)friendID forEvent:(Events )event;

/*
 * Description: updates points of a user with another user based on an event
 * Parameter: The user Id of the user whose points will be updated
 * Parameter: The user Id of the friend with whom the points will be updated
 * Parameter: The event based on which the points will be updated
 */
- (void) updatePoints:(NSString *)userID friend:(NSString *)friendID forEvent:(Events)event;

/*
 * Description: gets the points of the current user with his friend
 * Parameter: The user Id of the friend with whom the points are to be found out
 */
- (void) getCurrentPointsWithUserID:(NSString*)friendID WithCompletionHandler: (void(^)(PointModel *points))completion;

/*
 * Description: gets the points of a user with his friend
 * Parameter: The user Id of the user whose points are to be calculated
 * Parameter: The user Id of the friend with whom the points are to be calculated
 */
- (void) getPointOfUserID:(NSString*) userID andFriendID:(NSString *) friendID withCompletionHandler:(void(^)(PointModel *points,NSError *error))completion;
@end
