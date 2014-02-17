//
//  EmoticonController.h
//  Memoriz
//
//  Created by Zenan on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserController.h"
#import "EmotionStatus.h"

@interface EmoticonController : NSObject

@property (nonatomic, strong) EmotionStatus* currentStatus;


+ (EmoticonController*)sharedInstance;

/*
 * Method Name: getEmotionForUser
 * Description: get the current emotion for the specified user
 * Parameter: the friend's user objectID
 * Parameter: completion block
 */
+ (void)getEmotionForUser:(NSString*)friendId withCompletionHandler:(void(^)(EmotionStatus *emotion,NSError *error))completion;

/*
 * Method Name: getUserEmotionStatus
 * Description: get the current user emotion status
 * Parameter: completion block
 */
- (void)getUserEmotionStatus:(PFArrayResultBlock)completion;


/*
 * Method Name: updateUserEmotionStatus
 * Description: update the user's current emotion status
 * Parameter: current emotion number
 * Parameter: completion call back
 */
- (void)updateUserEmotionStatus:(NSInteger)currentEmotionNumber complete:(void(^)(BOOL success))callback;


@end
