//
//  PromiseController.h
//  Amigo
//
//  Created by qiyue song on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    notFulfill,                 //Whether the friend rejects for the fulfillment or the promise has passed the deadline.
    createdButNotFulfillYet,    //the promise has been created but still not fulfilled and not pass the deadline.
    fulfill                     //the promise has been accepted by the friend for fulfillment.
}fulfillmentType;

@interface PromiseController : NSObject

/*
 * Method Name: getPromisesForUser
 * Description: retrieve the all the promises with specific fulfillment state of specific user.
 * Parameter: userID of the specific Amigo user.
 * Parameter: the specific fulfillment state.
 * Parameter: callBack function to return the promise with specific fulfillment state list of the specific Amigo user.
 */
+ (void)getPromisesForUser:(NSString *)userID fulfillmentState:(NSNumber *)fulfillment  withCompletionHandler:(void(^)(NSArray * promises, NSError * error))completion;

/*
 * Method Name: acceptFulfillments
 * Description: accept the fulfillment of the specific promise.
 * Parameter: ID of the specific promise.
 * Parameter: callBack function to indicate if the promise has been set to be fulfilled successfully or not.
 */
+ (void)acceptFulfillments:(NSString *)promiseID withCompletionHandler:(void(^)(NSError * error))completion;

/*
 * Method Name: rejectFulfillments
 * Description: reject the fulfillment of the specific promise.
 * Parameter: ID of the specific promise.
 * Parameter: callBack function to indicate if the promise has been set to be not fulfilled successfully or not.
 */
+ (void)rejectFulfillments:(NSString *)promiseID withCompletionHandler:(void(^)(NSError * error))completion;

/*
 * Method Name: checkPromisesFulfillments
 * Description: check each promise which has not been fulfilled yet. If it has passed the deadline, it will be 
 *              updated as not fulfillin the fulfillmentState.
 */
+ (void)checkPromisesFulfillments;

@end
