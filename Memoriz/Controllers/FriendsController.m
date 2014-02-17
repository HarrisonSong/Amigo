//
//  FriendsController.m
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FriendsController.h"
#import "ServerController.h"
NSString *const KMRUserFacebookIDKey = @"facebookId";
NSString *const kMRFriendsClassKey = @"PFFriends";
NSString *const kMRFriendsFriendIDKey = @"friendID";
NSString *const kMRFriendsUserIDKey = @"userID";
NSString *const kMRFriendsUsernameKey = @"username";

@interface FriendsController()
{
    NSString *friendCacheKey;
}

@end

@implementation FriendsController

#pragma mark - Class Methods

+ (id)sharedInstance
{
    static FriendsController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[FriendsController alloc] init];
    });
    
    return __sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        friendQueue = dispatch_queue_create("sg.edu.nus.Amigo.friend",NULL);
    }
    return self;
}


+ (void)inviteFriends:(NSArray*)facebookIDArray withCompletionHandler:(void(^)(NSError *error))completion {
    
    if ([facebookIDArray count] == 0) {
        //return error if no facebook ID is read in.
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"No selection was made." forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"FBFriendPickerError" code:100 userInfo:errorDetail];
        completion(error);
    }
    
    for (NSString *facebookID in facebookIDArray) {
        
        DDLogVerbose(@"%@: %@, Friend FacebookID: %@",THIS_FILE,THIS_METHOD,facebookID);
        
        [ServerController queryUserWithConditions:@{KMRUserFacebookIDKey:facebookID} andCachePolicy:NO andCompletionHandler:^(NSArray *users, NSError *userError){
            //check if the Amigo user with specific facebookID exist.
            if(users.count == 0){
                //the user does not exist. Then check if the request has already been sent.
                [ServerController queryWithClassName:kMRRequestClassKey andConditions:@{KMRRequestUserIDKey:[PFUser currentUser],KMRRequestFBIDKey:facebookID} andCachePolicy:NO WithCompletionHandler:^(NSArray *objects, NSError *error) {
                    if(!error && objects.count == 0){
                        //no request has been sent. Then send the invition request.
                        InviteRequestModel *InviteRequest = [[InviteRequestModel alloc] init];
                        InviteRequest.fbID = facebookID;
                        InviteRequest.userID = [PFUser currentUser];
                        [InviteRequest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *requestError) {
                            if(succeeded){
                                completion(nil);
                            } else {
                                completion(requestError);
                            }
                        }];
                    }
                }];
            }
            else if(!userError){
                //the Amigo user with the specific facebookID exist.Then check if they are friends already.
                [ServerController queryWithClassName:kMRFriendsClassKey andConditions:@{kMRFriendsFriendIDKey:[users objectAtIndex:0],kMRFriendsUserIDKey:[PFUser currentUser]} WithCompletionHandler:^(NSArray *friendPairs, NSError *friendError) {
                    if(!friendError){
                        if(friendPairs.count == 0){
                            //they are not friends yet. Then check if request has been sent.
                            [ServerController queryWithClassName:kMRRequestClassKey andConditions:@{KMRRequestUserIDKey:[PFUser currentUser],KMRRequestFBIDKey:facebookID} andCachePolicy:NO WithCompletionHandler:^(NSArray *objects, NSError *error) {
                                if(!error && objects.count == 0){
                                    //no request has been sent. Then send the invition request.
                                    InviteRequestModel *InviteRequest = [[InviteRequestModel alloc] init];
                                    InviteRequest.fbID = facebookID;
                                    InviteRequest.userID = [PFUser currentUser];
                                    [InviteRequest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *requestError) {
                                        if(succeeded){
                                            completion(nil);
                                        } else {
                                            completion(requestError);
                                        }
                                    }];
                                }else{
                                    completion(error);
                                }
                            }];
                        }else{
                            completion(nil);
                        }
                    }else{
                        DDLogVerbose(@"Error: %@ %@", friendError, [friendError userInfo]);
                        completion(friendError);
                    }
                }];
            }else{
                DDLogVerbose(@"Error: %@ %@", userError, [userError userInfo]);
                completion(userError);
            }
        }];
    }
}

+ (void)getFriendsListWithCompletionHandler: (void(^)(NSArray *friendsArray, NSError *error))completion {
    
    UserModel *currentUser = (UserModel *)[UserModel currentUser];
    PFQuery *friendListquery = [PFQuery queryWithClassName:kMRFriendsClassKey];
    [friendListquery whereKey:kMRFriendsUserIDKey equalTo:currentUser];
    
    // Loads Cache first. Then checks server to update.
    friendListquery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    // Tells Query to populate data from this relation
    [friendListquery includeKey:kMRFriendsFriendIDKey];
    
    [friendListquery findObjectsInBackgroundWithBlock:^(NSArray *friendConnections, NSError *error) {
        
        if (!error) {
            
            DDLogVerbose(@"%@: %@, %d.", THIS_FILE,THIS_METHOD, friendConnections.count);
            
            // Form Array of Friends
            NSMutableArray *outputArray = [[NSMutableArray alloc] init];
            
            for (PFObject *friendConnection in friendConnections) {
                UserModel *friendObject = [friendConnection objectForKey:kMRFriendsFriendIDKey];
                [outputArray addObject:friendObject];
            }
            
            completion(outputArray,nil);
            
        } else {
            DDLogVerbose(@"Error: %@ %@", error, [error userInfo]);
            completion(nil,error);
        }
    }];
}

+ (void)getInviteRequestsWithCompletionHandler:(void(^)(NSArray *requestsArray, NSError *error))completion {
    
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *requestsQuery = [PFQuery queryWithClassName:kMRRequestClassKey];
    [requestsQuery whereKey:KMRRequestFBIDKey equalTo:currentUser[KMRUserFacebookIDKey]];

    // Loads Cache first. Then checks server to update.
    requestsQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;    
    
    // Tells Query to populate data from this relation
    [requestsQuery includeKey:KMRRequestUserIDKey];
    
    [requestsQuery findObjectsInBackgroundWithBlock:^(NSArray *requestConnections, NSError *error) {
        if (!error) {
            
            DDLogVerbose(@"%@: %@, %@.", THIS_FILE,THIS_METHOD, requestConnections);
            
            // Form Array of requests
            NSMutableArray *outputArray = [[NSMutableArray alloc] init];
            
            for (PFObject *requestConnection in requestConnections) {
                UserModel *requestUser = [requestConnection objectForKey:KMRRequestUserIDKey];
                [outputArray addObject:requestUser];
            }
            completion(outputArray,nil);
        } else {
            DDLogVerbose(@"Error: %@ %@", error, [error userInfo]);
            completion(nil,error);
        }
    }];
}

+ (void)getinvitionWithCompletionHandler: (void(^)(NSArray *requestsArray, NSError *error))completion{
    [ServerController queryWithClassName:kMRRequestClassKey andConditions:@{KMRRequestUserIDKey:[PFUser currentUser]} WithCompletionHandler:^(NSArray *results, NSError *error) {
        if (!error) {
            
            DDLogVerbose(@"%@: %@, %@.", THIS_FILE,THIS_METHOD, results);
            
            // Form Array of invitions
            NSMutableArray *outputArray = [[NSMutableArray alloc] init];
            
            for (PFObject *result in results) {
                NSString *requestFriendFBID = [result objectForKey:KMRRequestFBIDKey];
                [outputArray addObject:requestFriendFBID];
            }
            completion(outputArray,nil);
        } else {
            DDLogVerbose(@"Error: %@ %@", error, [error localizedDescription]);
            completion(nil,error);
        }
    }];
}

- (void)getInviteRequestCurrentFriendListWithCompletionHandler:(void(^)(NSArray *friendsArray, NSError *error))completion{
    
    friendCacheKey = [NSString stringWithFormat:@"friend%@",[[PFUser currentUser] objectId]];
    bool proceed = true;
    
    //check if the required facebookID list exists in cache or not.
    if ([[EGOCache globalCache] hasCacheForKey:friendCacheKey]) {
        proceed = false;
        completion((NSArray*)[[EGOCache globalCache] objectForKey:friendCacheKey],nil);
    }
    
    PFQuery * friendQuery = [PFQuery queryWithClassName:kMRFriendsClassKey];
    PFQuery * requestQuery = [PFQuery queryWithClassName:kMRRequestClassKey];
    PFQuery * invitionQuery = [PFQuery queryWithClassName:kMRRequestClassKey];
    [friendQuery whereKey:kMRFriendsUserIDKey equalTo:[PFUser currentUser]];
    [friendQuery includeKey:kMRFriendsFriendIDKey];
    [requestQuery whereKey:KMRRequestFBIDKey equalTo:[PFUser currentUser][KMRUserFacebookIDKey]];
    [requestQuery includeKey:KMRRequestUserIDKey];
    [invitionQuery whereKey:KMRRequestUserIDKey equalTo:[PFUser currentUser]];
    
    //dispatch the query tasks on the queue to run them in another thread asynchronously
    dispatch_async(friendQueue, ^{
        
        NSError *error = nil;
        NSArray *friendArray = [friendQuery findObjects:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil,error);
            });
            return;
        }
        
        NSArray *requestArray = [requestQuery findObjects:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil,error);
            });
            return;
        }
        
        NSArray *invitionArray = [invitionQuery findObjects:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil,error);
            });
            return;
        }
        
        NSMutableArray *outputArray = [[NSMutableArray alloc] init];
        
        //collect all the facebookIDs list after sequentially finishing the query task for each.
        for(PFObject * user in friendArray){
            [outputArray addObject:[[user objectForKey:kMRFriendsFriendIDKey] objectForKey:KMRUserFacebookIDKey]];
        }
        for(PFObject * user in requestArray){
            [outputArray addObject:[[user objectForKey:KMRRequestUserIDKey] objectForKey:KMRUserFacebookIDKey]];
        }
        for(PFObject * user in invitionArray){
            [outputArray addObject:[user objectForKey:KMRRequestFBIDKey]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[EGOCache globalCache] setObject:outputArray forKey:friendCacheKey];
            //if the callback function has been sent previously, no need to send again.
            if(proceed){
                completion(outputArray,nil);
            }
        });
    });
}

+(void)acceptInviteRequest:(NSString *)userID withCompletion:(void(^)(NSError *error))completion{
    PFObject *friendToUser = [PFObject objectWithClassName:kMRFriendsClassKey];
    PFObject *userToFriend = [PFObject objectWithClassName:kMRFriendsClassKey];
    [friendToUser setObject:[PFUser currentUser] forKey:kMRFriendsUserIDKey];
    [userToFriend setObject:[PFUser currentUser] forKey:kMRFriendsFriendIDKey];
    [ServerController queryUserWithConditions:@{@"objectId":userID} andCompletionHandler:^(NSArray *users, NSError *userError) {
        if(!userError){
            [friendToUser setObject:[users objectAtIndex:0] forKey:kMRFriendsFriendIDKey];
            [userToFriend setObject:[users objectAtIndex:0] forKey:kMRFriendsUserIDKey];
            [ServerController queryWithClassName:kMRRequestClassKey andConditions:@{KMRRequestUserIDKey:[users objectAtIndex:0]} WithCompletionHandler:^(NSArray *requests, NSError *requestError){
                if(!requestError){
                    if(requests.count!=0){
                        DDLogVerbose(@"%@: %@, %@.", THIS_FILE,THIS_METHOD, requests);
                        [[requests objectAtIndex:0] deleteInBackground];
                        [friendToUser saveInBackground];
                        [userToFriend saveInBackground];
                        completion(nil);
                    }
                }else {
                    DDLogVerbose(@"Error: %@ %@", requestError, [requestError userInfo]);
                    completion(requestError);
                }
            }];
        }else {
            DDLogVerbose(@"Error: %@ %@", userError, [userError userInfo]);
            completion(userError);
        }
    }];
}

+ (void)rejectInviteRequest:(NSString *)userID withCompletion:(void(^)(NSError *error))completion{
    [ServerController queryUserWithConditions:@{@"objectId":userID} andCompletionHandler:^(NSArray *users, NSError *userError) {
            if(!userError){
            DDLogVerbose(@"%@: %@, %@.", THIS_FILE,THIS_METHOD, [users objectAtIndex:0]);
            [ServerController queryWithClassName:kMRRequestClassKey andConditions:@{KMRRequestUserIDKey:[users objectAtIndex:0]} WithCompletionHandler:^(NSArray *requests, NSError *requestError){
                if(!requestError) {
                    if(requests.count!=0){
                        DDLogVerbose(@"%@: %@, %@.", THIS_FILE,THIS_METHOD, requests);
                        [[requests objectAtIndex:0] deleteInBackground];
                        completion(nil);
                    }
                }else{
                    DDLogVerbose(@"Error: %@ %@", requestError, [requestError userInfo]);
                    completion(requestError);
                }
            }];
        }else{
            DDLogVerbose(@"Error: %@ %@", userError, [userError userInfo]);
            completion(userError);
        }
    }];
}

+ (void)deleteInvition:(NSString *)FBID withCompletion:(void(^)(NSError *error))completion{
    [ServerController queryWithClassName:kMRRequestClassKey andConditions:@{KMRRequestUserIDKey:[PFUser currentUser],KMRRequestFBIDKey:FBID} WithCompletionHandler:^(NSArray *results, NSError *error) {
        if(!error){
            DDLogVerbose(@"%@: %@, %@.", THIS_FILE,THIS_METHOD, results);
            if ([results count] > 0) {
                [((PFObject*)[results objectAtIndex:0]) deleteInBackground];
                completion(nil);
            }
        }else{
            DDLogVerbose(@"Error: %@ %@", error, [error userInfo]);
            completion(error);
        }
    }];
}

+ (void)unfriend:(NSString *)friendID{
    
    UserModel *currentUser = (UserModel *)[UserModel currentUser];
    [ServerController queryUserWithConditions:@{@"objectId":friendID} andCompletionHandler:^(NSArray *results, NSError *error){
        //check if user with the specific ID exists.
        if(!error) {
            UserModel *friend = (UserModel *) [results objectAtIndex:0];
            NSDictionary *friendToUserConditions = @{kMRFriendsFriendIDKey: friend, kMRFriendsUserIDKey: currentUser};
            NSDictionary *userToFriendConditions = @{kMRFriendsUserIDKey: friend, kMRFriendsFriendIDKey: currentUser};
            [ServerController queryWithClassName:kMRFriendsClassKey andConditions:friendToUserConditions WithCompletionHandler:^(NSArray *friendToUserResults, NSError *error) {
                //check if the current user and the specific user are friends or not.
                if(!error) {
                    DDLogVerbose(@"%@: %@, %@.", THIS_FILE,THIS_METHOD, friendToUserResults);
                    [ServerController queryWithClassName:kMRFriendsClassKey andConditions:userToFriendConditions WithCompletionHandler:^(NSArray *userToFriendResults, NSError *error) {
                        if(!error) {
                            DDLogVerbose(@"%@: %@, %@.", THIS_FILE,THIS_METHOD, userToFriendResults);
                            
                            //remove the friends relations.
                            [[friendToUserResults objectAtIndex:0] deleteInBackground];
                            [[userToFriendResults objectAtIndex:0] deleteInBackground];
                        } else {
                            DDLogVerbose(@"Error: %@ %@", error, [error userInfo]);
                        }
                    }];
                } else {
                    DDLogVerbose(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        } else {
            DDLogVerbose(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
@end
