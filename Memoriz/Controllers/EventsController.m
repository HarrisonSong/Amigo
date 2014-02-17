//
//  EventsController.m
//  Amigo
//
//  Created by Zenan on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "EventsController.h"
#import "UserController.h"
#import "ServerController.h"

@implementation EventsController


+ (id)sharedInstance
{
    static EventsController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[EventsController alloc] init];
    });
    
    return __sharedInstance;
}

+ (void)getUserFacebookEventsWithCompletionHandler:(void(^)(NSError *error, NSArray *events))completion
{
    [FBRequestConnection startWithGraphPath:@"me/events" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        DDLogCVerbose(@"facebook event:%@, with error:%@", result, error);
        if (!error) {
            NSArray *resultData = [result objectForKey:@"data"];
            
            if ([resultData count] > 0) {
                NSMutableArray *eventSet = [NSMutableArray array];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZZZ"];
                
                for (NSDictionary *event in resultData) {
                    
                    EventModel *newEvent = [[EventModel alloc] init];
                    newEvent.postType = kEventPost;
                    if ([event objectForKey:@"id"]) {
                        newEvent.fbEventID = [event objectForKey:@"id"];
                    }
                    
                    if ([event objectForKey:@"name"]) {
                        newEvent.name = [event objectForKey:@"name"];
                        
                    }
                    
                    if ([event objectForKey:@"description"]) {
                        newEvent.desc = [event objectForKey:@"description"];
                    }
                    
                    if ([event objectForKey:@"start_time"]) {
                        NSString *startTimeString = [event objectForKey:@"start_time"];
                        NSDate *startTime = [dateFormatter dateFromString:startTimeString];
                        if(startTime) {
                            newEvent.startTime = startTime;
                        }
                        NSLog(@"%@", startTime);
                    }
                    
                    if ([event objectForKey:@"end_time"]) {
                        NSString *endTimeString = [event objectForKey:@"end_time"];
                        NSDate *endTime = [dateFormatter dateFromString:endTimeString];
                        if (endTime) {
                            newEvent.endTime = endTime;
                        }
                    }
                    
                    if ([event objectForKey:@"location"]) {
                        newEvent.location = [event objectForKey:@"location"];
                    }
                    [eventSet addObject:newEvent];
                }
        
                completion(error, eventSet);
            } else {
                completion(error, nil);
            }
     
     } else {
         completion(error, nil);
     }
     }];
    
}

+ (void)inviteFriend:(UserModel*)friendUser ToEvent:(EventModel*)event Completion:(void(^)(NSError *error))completion
{
    [[UserController sharedInstance] fetchFacebookIDForUser:friendUser.objectId WithCompletionHandler:^(NSString *facebookID) {
        if (facebookID) {
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/invited/%@", event.fbEventID, facebookID]
                                 parameters:[NSDictionary dictionary]
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              DDLogCVerbose(@"invite event:%@, with error:%@", result, error);
                          }];
        }
    }];

}

+ (void)getInvitedEventToFriend:(UserModel*)friendUser Completion:(void(^)(NSError *error, NSArray *result))completion
{
    UserModel *current = [[UserController sharedInstance] fetchCurrentUser];
    
    [ServerController queryWithClassName:kMRPostEventClassKey
                                            andConditions:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           current.objectId, kMRPostCreatorUserIDKey,
                                                           friendUser.objectId, kMRPostToUserIDKey, nil]
                                           andCachePolicy:NO
                                    WithCompletionHandler:^(NSArray *result, NSError *error) {
                                        DDLogCVerbose(@"get invited event:%@, with error:%@", result, error);
                                        completion(error, result);
    }];
    
}

+ (void) goingToEvent:(EventModel *)event Completion:(void (^)(NSError *))completion
{
    UserModel *current = [[UserController sharedInstance] fetchCurrentUser];
    
    if ([current.objectId isEqualToString:event.postToUserID]) {
        
        event.isGoing = YES;
        [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            completion(error);
        }];
        
        [[UserController sharedInstance] fetchFacebookIDForUser:current.objectId WithCompletionHandler:^(NSString *facebookID) {
            if (facebookID) {
                [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/attending", event.fbEventID]
                                             parameters:[NSDictionary dictionary]
                                             HTTPMethod:@"POST"
                                      completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                          DDLogCVerbose(@"accept event:%@, with error:%@", result, error);
                                      }];
            }
        }];
        
    } else {
        completion([NSError errorWithDomain:@"Wrong user" code:1 userInfo:nil]);
    }
    
}

@end
