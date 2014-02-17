//
//  ServerController.m
//  Memoriz
//
//  Created by Inian Parameshwaran on 27/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "UserController.h"
#import "PhotoModel.h"
#import "MessageModel.h"
#import "PromiseModel.h"
#import "InviteRequestModel.h"
#import "EmotionStatus.h"
#import "ServerController.h"
#import <Parse/PFObject+Subclass.h>
#import "FacebookPhotoModel.h"
#import "FacebookPhotoGroupModel.h"

#define FACEBOOK_ID_KEY @"fb_id_for_%@"
#define FACEBOOK_COVER_BASE_URL @"http://graph.facebook.com/%@?fields=cover"
#define FACEBOOK_POST_TO_FEED_URL @"/me/feed"

@implementation UserController

+ (id)sharedInstance
{
    static UserController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[UserController alloc] init];
    });
    
    return __sharedInstance;
}

- (BOOL)isLoggedIn {
    return [FBSession activeSession].isOpen && [[PFUser currentUser] isAuthenticated];
}

- (void)loginFaceBookUser
{
    NSArray *permissionsArray = @[ @"email", @"user_about_me", @"user_photos", @"friends_photos", @"publish_actions", @"friends_about_me", @"friends_birthday", @"user_likes", @"friends_likes",@"friends_relationships",@"user_relationships", @"friends_hometown", @"friends_videos", @"user_videos", @"user_photo_video_tags", @"friends_photo_video_tags", @"user_checkins", @"friends_checkins", @"user_activities", @"friends_activities", @"user_games_activity", @"friends_games_activity", @"user_events", @"create_event", @"rsvp_event"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            if (!error) {
                DDLogVerbose(@"Uh oh. The user cancelled the Facebook login.");
                [self.loginDelegate facebookLoginFailedWithError:nil];
            } else {
                DDLogVerbose(@"Uh oh. An error occurred: %@", error);
                [self.loginDelegate facebookLoginFailedWithError:error];
            }
            
        } else if (user.isNew) {
            [self fetchFacebookDetailsWithCompletionHandler:^{
                [self.loginDelegate facebookLoginSuccessWithNewUser];
            }];
            
        } else {
            [self fetchFacebookDetailsWithCompletionHandler:^{
                [self.loginDelegate facebookLoginSuccessWithExistingUser];
            }]; // Temporary so that everyone's data will be in
        }
    }];
}


- (void)fetchFacebookDetailsWithCompletionHandler: (void(^)())completion {
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,result);
        
        NSDictionary *facebookDetails = [NSDictionary dictionaryWithDictionary:result];
        UserModel *currentUser = (UserModel *)[UserModel currentUser];
        [currentUser setEmail:[facebookDetails objectForKey:@"email"]];
        [currentUser setObject:[facebookDetails objectForKey:@"id"] forKey:kMRUserFacebookIdKey];
        [currentUser setObject:[facebookDetails objectForKey:@"name"] forKey:kMRUserDisplayNameKey];
        
        [currentUser saveInBackgroundWithTarget:[ServerController sharedInstance] selector:@selector(attachUserToInstallation)];
        
        completion();
    }];
}

- (UserModel*)fetchCurrentUser {
    return (UserModel*)[UserModel currentUser];
}

- (void)fetchUserForUserID:(NSString*)userId WithCompletionHandler: (void(^)(UserModel *user))completion {
    [ServerController queryUserWithConditions:@{kMRUserObjectIdKey:userId} andCompletionHandler:^(NSArray *results, NSError *error) {
        if(!error && results.count > 0) {
            UserModel *user = [results objectAtIndex:0];
            completion(user);
        } else {
            completion(nil);
        }
    }];
}

- (void)fetchFacebookIDForUser:(NSString*)userId WithCompletionHandler: (void(^)(NSString *facebookID))completion {
    
    if ([[EGOCache globalCache] hasCacheForKey:[NSString stringWithFormat:FACEBOOK_ID_KEY, userId]]) {
        completion ((NSString*)[[EGOCache globalCache] objectForKey:[NSString stringWithFormat:FACEBOOK_ID_KEY, userId]]);
        return;
    }
    
    [self fetchUserForUserID:userId WithCompletionHandler:^(UserModel *user) {
        if (user) {
            [[EGOCache globalCache] setObject:[user objectForKey:kMRUserFacebookIdKey] forKey:[NSString stringWithFormat:FACEBOOK_ID_KEY, userId]];
            completion ([user objectForKey:kMRUserFacebookIdKey]);
        } else {
            completion(nil);
        }
    }];
}

- (void)fetchFacebookCoverURLForFacebookId:(NSString*)facebookId WithCompletionHandler: (void(^)(NSURL *coverURL, NSError *error))completion {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:FACEBOOK_COVER_BASE_URL,facebookId]];

    [ServerController requestJSON:url WithCompletionHandler:^(id JSON, NSError *error) {
            completion([NSURL URLWithString:[[[JSON objectForKey:@"cover"] objectForKey:@"source"]stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]],nil);
    }];
    
}

- (void)postToFacebookWall:(NSString*)message withCompletionHandler: (void(^)(BOOL successs))completion {
    [FBRequestConnection startWithGraphPath:FACEBOOK_POST_TO_FEED_URL parameters:@{@"message": message} HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            completion(YES);
        } else {
            DDLogError(@"Facebook Wall Post Error: %@", [error localizedDescription]);
        }
    }];
}



-(void)getFacebookPhotosWithFriend:(NSString *)userID withCompletionHandler: (void(^)(NSArray *photos, NSError *error))completion
{
    
    [ServerController queryUserWithConditions:@{kMRUserObjectIdKey:userID} andCompletionHandler:^(NSArray *results, NSError *error) {
        UserModel *friend = (UserModel *)[results objectAtIndex:0];
        NSString *fbID = [friend objectForKey:kMRUserFacebookIdKey];
        NSString *query = [NSString stringWithFormat:@"SELECT pid, src, src_big, created FROM photo WHERE pid IN( SELECT pid FROM photo_tag WHERE subject = %lld ) AND pid IN( SELECT pid FROM photo_tag WHERE subject = me()) ORDER by created ASC", [fbID longLongValue]];
        NSDictionary *params = [NSDictionary dictionaryWithObject:query forKey:@"q"];
        
        [FBRequestConnection startWithGraphPath:@"/fql" parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(!error) {
            NSMutableArray *allPhotos = [[NSMutableArray alloc] init]; //array of facebookphotogroup
            
            NSTimeInterval interval = PHOTOS_GROUP_TIME;
            NSArray *results = [result objectForKey:@"data"];
            NSDate *prev = [NSDate distantPast];
            FacebookPhotoGroupModel *photosInDay;
            for (int i = 0 ; i < results.count; i++) {
                NSDictionary *photoResult = [results objectAtIndex:i];
                NSDate *photoDate = [NSDate dateWithTimeIntervalSince1970:[[photoResult objectForKey:@"created"] doubleValue]];
                
                FacebookPhotoModel *photoModel = [[FacebookPhotoModel alloc] init];
                photoModel.photoId = [photoResult objectForKey:@"pid"];
                photoModel.bigPhotoURL = [NSURL URLWithString:[photoResult objectForKey:@"src_big"]];
                photoModel.smallPhotoURL = [NSURL URLWithString:[photoResult objectForKey:@"src"]];
                photoModel.createdAt = photoDate;
                
                if([photoDate timeIntervalSinceDate:prev] > interval) {
                    photosInDay = [[FacebookPhotoGroupModel alloc] init];
                    photosInDay.createdAt = photoDate;
                    photosInDay.facebookPhotos = [[NSMutableArray alloc] init];
                    [allPhotos addObject:photosInDay];
                    prev = photoDate;
                }
                //add photo to photos in day
                [photosInDay.facebookPhotos addObject:photoModel];
            }
            completion(allPhotos, nil);
            } else {
                DDLogError(@"error pulling facebook photos : %@", [error localizedDescription]);
                completion(nil, error);
            }
        }];
    }];
}

- (void)logout {
    [PFUser logOut];
}


@end
