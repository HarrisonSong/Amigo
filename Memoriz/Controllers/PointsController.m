//
//  PointsController.m
//  Memoriz
//
//  Created by Inian Parameshwaran on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "PointsController.h"
#import "UserModel.h"
#import "UserController.h"
#import "ServerController.h"
#import "PointModel.h"

NSString *const PointsControllerDidUpdatePoints = @"PointsControllerDidUpdatePoints";

@implementation PointsController

+ (id)sharedInstance
{
    static PointsController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[PointsController alloc] init];
    });
    
    return __sharedInstance;
}

- (void) getCurrentPointsWithUserID:(NSString*)friendID WithCompletionHandler: (void(^)(PointModel *points))completion{
    NSString *currentUserID = [[UserModel currentUser] objectId];
    [self getPointOfUserID:currentUserID andFriendID:friendID withCompletionHandler:^(PointModel *points, NSError *error) {
        completion(points);
    }];
}

-(void)getPointOfUserID:(NSString*) userID andFriendID:(NSString *) friendID withCompletionHandler:(void(^)(PointModel *points,NSError *error))completion;
{
    __block PointModel *point = [[PointModel alloc] init];
    
    NSDictionary *queryConditions = [[NSDictionary alloc] initWithObjectsAndKeys:friendID, kMRPointFriendIdKey, userID, kMRPointUserIdKey, nil];
    [ServerController queryWithClassName:kMRPointClassKey andConditions:queryConditions WithCompletionHandler:^(NSArray *results, NSError *error) {
        if(!error) {
            if(results.count != 0) {
                point = [results objectAtIndex:0];
            } else {
                //point object does not exist, creating the point object
                point.userID = userID;
                point.friendID = friendID;
            }
            completion(point, nil);
        } else {
            completion (nil, error);
        }
    }];
}

-(void) updatePointsWithUserID:(NSString *)friendID forEvent:(Events)event
{
    NSString *currentUserID = [(UserModel*)[UserModel currentUser] objectId];
    [self getPointOfUserID:currentUserID andFriendID:friendID withCompletionHandler:^(PointModel *points, NSError *error) {
        switch (event) {
            case kTimeLinePostEvent:
                points.points += TIMELINE_POST_POINTS;
                break;
            case kTimeLinePhotoEvent:
                points.points += TIMELINE_PHOTO_POINTS;
                break;
            case kTimeLineCommentEvent:
                points.points += TIMELINE_POST_COMMENT;
                break;
            case kPromiseEvent:
                points.points += PROMISE_POST_POINTS;
                break;
            case kPromiseCompleteEvent:
                points.points += PROMISE_COMPLETE_POINTS;
                break;
            case kPromiseFailEvent:
                points.points += PROMISE_FAIL_POINTS;
                break;
                
            default:
                break;
        }
        if (points.points < 0) {
            NSLog(@"points are being set to a negative value");
        }
        [points saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[NSNotificationCenter defaultCenter] postNotificationName:PointsControllerDidUpdatePoints object:nil];
            }
        }];
    }];
}

-(void) updatePoints:(NSString *)userID friend:(NSString *)friendID forEvent:(Events)event
{
    [self getPointOfUserID:userID andFriendID:friendID withCompletionHandler:^(PointModel *points, NSError *error) {
        switch (event) {
            case kTimeLinePostEvent:
                points.points += TIMELINE_POST_POINTS;
                break;
            case kTimeLinePhotoEvent:
                points.points += TIMELINE_PHOTO_POINTS;
                break;
            case kTimeLineCommentEvent:
                points.points += TIMELINE_POST_COMMENT;
                break;
            case kPromiseEvent:
                points.points += PROMISE_POST_POINTS;
                break;
            case kPromiseCompleteEvent:
                points.points += PROMISE_COMPLETE_POINTS;
                break;
            case kPromiseFailEvent:
                points.points += PROMISE_FAIL_POINTS;
                break;
                
            default:
                break;
        }
        if (points.points < 0) {
            NSLog(@"points are being set to a negative value");
        }
        [points saveInBackground];
    }];
}

@end
