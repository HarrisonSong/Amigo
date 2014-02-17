//
//  EmoticonController.m
//  Memoriz
//
//  Created by Zenan on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "EmoticonController.h"
#import "ServerController.h"

@implementation EmoticonController

+ (EmoticonController*) sharedInstance
{
    static EmoticonController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[EmoticonController alloc] init];
    });
    
    return __sharedInstance;
}

+ (void)getEmotionForUser:(NSString*)friendId withCompletionHandler:(void(^)(EmotionStatus *emotion,NSError *error))completion{
    NSDictionary *conditions = [[NSDictionary alloc] initWithObjectsAndKeys:friendId, kMREmotionStatusUserID, nil];
    [ServerController queryWithClassName:kMREmotionStatusKey andConditions:conditions WithCompletionHandler:^(NSArray *results, NSError *error) {
        if(!error){
            DDLogVerbose(@"%@: %@, Friend emotion Number: %@",THIS_FILE,THIS_METHOD,[results objectAtIndex:0]);
            completion([results objectAtIndex:0],nil);
        }else{
            DDLogVerbose(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

- (void)getUserEmotionStatus:(PFArrayResultBlock)completion
{
    UserModel *currentUser = (UserModel *)[PFUser currentUser];
    [ServerController queryWithClassName:kMREmotionStatusKey andConditions:@{kMREmotionStatusUserID:currentUser.objectId} WithCompletionHandler:^(NSArray *results, NSError *error) {
        NSLog(@"Successfully retrieved %d emotion status.", results.count);
        if (completion) {
            if ([results count] > 0) {
                EmotionStatus *status = (EmotionStatus*)[results objectAtIndex:0];
                self.currentStatus = status;
            }
            completion(results, nil);
        }
    }];
}

- (void)updateUserEmotionStatus:(NSInteger)currentEmotionNumber complete:(void(^)(BOOL success))callback
{
    UserModel *currentUser = (UserModel *)[UserModel currentUser];

    if (self.currentStatus) {
        self.currentStatus.userId = currentUser.objectId;
        self.currentStatus.emotionNumber = currentEmotionNumber;
        
        [self.currentStatus saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"succeeded:%@, error:%@", (succeeded?@"YES":@"NO"), error);
            callback(succeeded);
        }];
    } else {
        [self createNewDefaultEmotionStatus];
    }
}

- (void)createNewDefaultEmotionStatus
{
    UserModel *currentUser = (UserModel *)[UserModel currentUser];
    EmotionStatus *newStatus = [[EmotionStatus alloc] init];
    newStatus.emotionNumber = 1;
    newStatus.userId = currentUser.objectId;
    [newStatus saveInBackground];
    self.currentStatus = newStatus;
}

@end
