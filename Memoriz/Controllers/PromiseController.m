//
//  PromiseController.m
//  Amigo
//
//  Created by qiyue song on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "PromiseController.h"
#import "PointsController.h"
#import "PromiseModel.h"
#import "ServerController.h"

@implementation PromiseController

+ (void)getPromisesForUser:(NSString *)userID fulfillmentState:(NSNumber *)fulfillment withCompletionHandler:(void (^)(NSArray * promises, NSError * error))completion{
    [ServerController queryWithClassName:kMRPostPromiseClassKey andConditions:@{kMRPostToUserIDKey:userID,kMRPromisefulfillmentKey:fulfillment} andCachePolicy:NO WithCompletionHandler:^(NSArray * promises, NSError * promiseError) {
        if(!promiseError){
            NSMutableArray * outArray = [[NSMutableArray alloc] init];
            for(PromiseModel * promise in promises){
                [outArray addObject:promise];
            }
            completion(promises,nil);
        }else{
            DDLogVerbose(@"Error: %@ %@", promiseError, [promiseError userInfo]);
            completion(nil,promiseError);
        }
    }];
}

+ (void)acceptFulfillments:(NSString *)promiseID withCompletionHandler:(void(^)(NSError * error))completion{
    [ServerController queryWithClassName:kMRPostPromiseClassKey andConditions:@{@"objectId":promiseID} andCachePolicy:NO WithCompletionHandler:^(NSArray * promises, NSError * promiseError){
        if(!promiseError){
            
            if ([promises count] > 0) {
                ((PromiseModel*)promises[0]).fulfillment = [NSNumber numberWithInt:fulfill];
                [promises[0] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded&&!error){
                        [[PointsController sharedInstance] updatePoints:[promises[0] objectForKey:kMRPostToUserIDKey] friend:[promises[0] objectForKey:kMRPostCreatorUserIDKey] forEvent:PROMISE_POST_POINTS];
                        completion(nil);
                    }else{
                        completion(error);
                    }
                }];
            } // End Promise Count > 0
            
        } else{
            completion(promiseError);
        }
    }];
}

+ (void)rejectFulfillments:(NSString *)promiseID withCompletionHandler:(void(^)(NSError * error))completion{
    [ServerController queryWithClassName:kMRPostPromiseClassKey andConditions:@{@"objectId":promiseID} andCachePolicy:NO WithCompletionHandler:^(NSArray * promises, NSError * promiseError){
        if(!promiseError){
            if ([promises count] > 0) {
                ((PromiseModel*)promises[0]).fulfillment = [NSNumber numberWithInt:notFulfill];
                [promises[0] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded&&!error){
                        [[PointsController sharedInstance] updatePoints:[promises[0] objectForKey:kMRPostToUserIDKey] friend:[promises[0] objectForKey:kMRPostCreatorUserIDKey] forEvent:PROMISE_FAIL_POINTS];
                        completion(nil);
                    }else{
                        completion(error);
                    }
                }];
            } // End Promise Count > 0
            
        } else {
            completion(promiseError);
        }
    }];
}

+ (void)checkPromisesFulfillments{
    //only check the fulfillments of the promises that are created but not fulfilled yet and not pass the deadlines.
    [ServerController queryWithClassName:kMRPostPromiseClassKey andConditions:@{kMRPromisefulfillmentKey:[NSNumber numberWithInt:createdButNotFulfillYet]} andCachePolicy:NO WithCompletionHandler:^(NSArray * results, NSError *error) {
        if(!error){
            NSDate * currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
            for(PromiseModel * promise in results){
                if([promise.promiseDeadline compare:currentDate] == NSOrderedAscending){
                    promise.fulfillment = [NSNumber numberWithInt:notFulfill];
                    [promise saveInBackground];
                    [[PointsController sharedInstance] updatePoints:[promise objectForKey:kMRPostToUserIDKey] friend:[promise objectForKey:kMRPostCreatorUserIDKey] forEvent:PROMISE_FAIL_POINTS];
                }
            }
        }else{
            DDLogVerbose(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
@end
