//
//  ServerController.m
//  Memoriz
//
//  Created by Inian Parameshwaran on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ServerController.h"
#import "PhotoModel.h"
#import "MessageModel.h"
#import "PromiseModel.h"
#import "EventModel.h"
#import "InviteRequestModel.h"
#import "EmotionStatus.h"
#import "PointModel.h"
#import "CommentsModel.h"
#import "AchievementModel.h"

NSString * const kCacheConstraint = @"cache";
NSString * const kLimitConstraint = @"limit";
NSString * const kOffsetConstraint = @"offset";
NSString * const kCountQueryConstraint = @"count";

@implementation ServerController

+ (id)sharedInstance
{
    static ServerController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[ServerController alloc] init];
    });
    
    return __sharedInstance;
}

#pragma mark - methods for application setup
- (void)setupServerControllerWithLaunchOptions:(NSDictionary *)launchOptions
{
    
    [UserModel registerSubclass];
    [PhotoModel registerSubclass];
    [MessageModel registerSubclass];
    [PromiseModel registerSubclass];
    [EventModel registerSubclass];
    [EmotionStatus registerSubclass];
    [PointModel registerSubclass];
    [InviteRequestModel registerSubclass];
    [CommentsModel registerSubclass];
    [AchievementModel registerSubclass];
    
    
    [Parse setApplicationId:PARSE_APPLICATION_ID
                  clientKey:PARSE_CLIENT_ID];
    [PFFacebookUtils initializeFacebook];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
#ifdef DEBUG
    [Parse errorMessagesEnabled:YES];
#endif
    
    self.s3Controller = [[S3Controller alloc] init];
    self.imageDictionary = [NSMutableDictionary new];
}

- (void) registerNotificationForDeviceWithToken:(NSData *)deviceToken
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void) receiveRemoteNotificationForDeviceWithToken:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}

- (void) attachUserToInstallation
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if(currentInstallation.deviceToken) {
        [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
        [currentInstallation saveInBackground];
    } 
}

#pragma mark - query methods
+(void) queryWithClassName:(NSString *) type andConditions:(NSDictionary *) conditions WithCompletionHandler: (void(^)(NSArray *results, NSError *error))completion;
{
    PFQuery *query = [PFQuery queryWithClassName:type];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    for (NSString* key in conditions) {
        [query whereKey:key equalTo:[conditions objectForKey:key]];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            DDLogVerbose(@"%@: %@, Results array: %@",THIS_FILE,THIS_METHOD, objects);
            completion(objects, nil);
        }else{
            DDLogVerbose(@"Error: %@ %@", error, [error userInfo]);
            completion(nil, error);
        }
    }];
}

+(void) queryWithClassName:(NSString *)type andConditions:(NSDictionary *)conditions andConstraints:(NSDictionary *)constraints WithCompletionHandler:(void (^)(NSArray *, NSError *))completion
{
    PFQuery *query = [PFQuery queryWithClassName:type];
    
    //applying conditions
    for (NSString* key in conditions) {
        [query whereKey:key equalTo:[conditions objectForKey:key]];
    }
    
    BOOL iSCountQuery = NO;
    //applying constraints
    for (NSString* key in constraints) {
        id value = [conditions objectForKey:key];
        if ([key isEqualToString:kCacheConstraint]) {
            if (!(BOOL) value) {
                query.cachePolicy = kPFCachePolicyNetworkOnly;
            } else {
                query.cachePolicy = kPFCachePolicyCacheThenNetwork;
            }
        } else if ([key isEqualToString:kLimitConstraint]) {
            query.limit = [value intValue];
        } else if ([key isEqualToString:kOffsetConstraint]) {
            query.skip = [value intValue];
        } else if ([key isEqualToString:kCountQueryConstraint]) {
            iSCountQuery = (BOOL) value;
        }
    }
    
    if(iSCountQuery) {
        [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if(!error){
                DDLogVerbose(@"%@: %@, Count is: %d",THIS_FILE,THIS_METHOD, number);
                completion([NSArray arrayWithObject:[NSNumber numberWithInt:number]], nil);
            }else{
                DDLogVerbose(@"Error: %@ %@", error, [error userInfo]);
                completion(nil, error);
            }
        }];
    } else {
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error){
                DDLogVerbose(@"%@: %@, Results array: %@",THIS_FILE,THIS_METHOD, objects);
                completion(objects, nil);
            }else{
                DDLogVerbose(@"Error: %@ %@", error, [error userInfo]);
                completion(nil, error);
            }
        }];
    }
}

+(void) queryWithClassName:(NSString *)type andConditions:(NSDictionary *)conditions andCachePolicy:(BOOL) cachePolicy WithCompletionHandler:(void (^)(NSArray *, NSError *))completion
{
    PFQuery *query = [PFQuery queryWithClassName:type];
    
    if(cachePolicy) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    } else {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    for (NSString* key in conditions) {
        [query whereKey:key equalTo:[conditions objectForKey:key]];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            DDLogVerbose(@"%@: %@, Results array: %@",THIS_FILE,THIS_METHOD, objects);
            completion(objects, nil);
        }else{
            DDLogVerbose(@"Error: %@ %@", error, [error userInfo]);
            completion(nil, error);
        }
    }];
}

+(void) queryUserWithConditions:(NSDictionary *) conditions andCompletionHandler: (void(^)(NSArray *results, NSError *error))completion;
{
    PFQuery *query = [PFUser query];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    for (NSString* key in conditions) {
        [query whereKey:key equalTo:[conditions objectForKey:key]];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            DDLogVerbose(@"%@: %@, Results array: %@",THIS_FILE,THIS_METHOD, objects);
            completion(objects, nil);
        }else{
            DDLogVerbose(@"Error: %@ %@", error, [error userInfo]);
            completion(nil, error);
        }
    }];
}

+(void) queryUserWithConditions:(NSDictionary *) conditions andCachePolicy:(BOOL)cachePolicy andCompletionHandler: (void(^)(NSArray *results, NSError *error))completion;
{
    PFQuery *query = [PFUser query];
    
    if (cachePolicy) {
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    } else {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    for (NSString* key in conditions) {
        [query whereKey:key equalTo:[conditions objectForKey:key]];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            DDLogVerbose(@"%@: %@, Results array: %@",THIS_FILE,THIS_METHOD, objects);
            completion(objects, nil);
        }else{
            DDLogVerbose(@"Error: %@ %@", error, [error userInfo]);
            completion(nil, error);
        }
    }];
}

#pragma mark - networking methods
+(void) requestJSON:(NSURL *) url WithCompletionHandler: (void(^)(id JSON, NSError *error))completion {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completion(JSON ,nil);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completion(nil,error);
    }];
    
    [operation start];
}

#pragma mark - push notification methods
-(void) sendPushNotificationToUsers: (NSArray *)userModels withData:(NSDictionary *)data
{
    PFQuery *query = [PFInstallation query];
    [query whereKey:@"user" containedIn:userModels];

    PFPush *push = [[PFPush alloc] init];
    [push setQuery:query];
    [push setData:data];
    [push sendPushInBackground];
}

-(void) resetBadgeCount
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

#pragma mark - mail methods
+ (void)sendWelcomeEmailToId:(NSString *) mail
{
    id response = [PFCloud callFunction:@"sendMail" withParameters:@{@"toMail": mail}];
    DDLogVerbose(@"the response is %@", response);
}

@end
