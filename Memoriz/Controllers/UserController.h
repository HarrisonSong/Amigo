//
//  ServerController.h
//  Memoriz
//
//  Created by Inian Parameshwaran on 27/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UserModel.h"

@protocol FacebookLoginDelegate <NSObject>

- (void) facebookLoginSuccessWithExistingUser;
- (void) facebookLoginSuccessWithNewUser;
- (void) facebookLoginFailedWithError:(NSError *)error;

@end

@interface UserController : NSObject

@property (nonatomic, weak) id<FacebookLoginDelegate> loginDelegate;

// Singleton
+ (UserController *)sharedInstance;

/*
 * Method name: isLoggedIn
 * Description: Returns the logged in status of the user
 */
- (BOOL)isLoggedIn;

/*
 * Method name: loginFacebookUser
 * Description: Logs in the user using Facebook with the permissions 
                required by the application
 */
- (void)loginFaceBookUser;

/*
 * Method name:fetchFacebookDetailsWithCompletionHandler
 * Parameters: void(^)()
 * Description: Gets the details of the Facebook details of the currently
                logged in user
 */
- (void)fetchFacebookDetailsWithCompletionHandler: (void(^)())completion;

/*
 * Method name: fetchCurrentUser
 * Description: returns the currently logged in user
 */
- (UserModel*)fetchCurrentUser;

/*
 * Method name: fetchUserForUserID: WithCompletionHandler:
 * Paramters: NSString, void(^)(UserModel *)
 * Description: Convenience method for querying a user with User ID
 */
- (void)fetchUserForUserID:(NSString*)userId WithCompletionHandler: (void(^)(UserModel *user))completion;

/*
 * Method name: fetchFacebookIDForUser: WithCompletionHandler:
 * Parameters: NSString and void(^)(NSString *)
 * Description: returns the facebookId of the user using the completion handler
 */
- (void)fetchFacebookIDForUser:(NSString*)userId WithCompletionHandler: (void(^)(NSString *facebookID))completion;

/*
 * Method name: fetchFacebookCoverURLForFacebookId: WithCompletionHandler:
 * Parameters: NSString and (void(^) (NSURL *, NSError *))
 * Description: returns the URL of the cover photo using the completion handler
 */
- (void)fetchFacebookCoverURLForFacebookId:(NSString*)userID WithCompletionHandler: (void(^)(NSURL *coverURL, NSError *error))completion;

/*
 * Method name: postToFacebookWall: withCompletionHandler:
 * Parameters: NSString and (void(^)(BOOL))
 * Description: Posts a message to the wall of the current user
 */
- (void)postToFacebookWall:(NSString*)message withCompletionHandler: (void(^)(BOOL successs))completion;

/*
 * Method name: getFacebookPhotosWithFriend: withCompletionHandler:
 * Parameters: NSString and (void(^)(NSArray *, NSError *))
 * Description: Gets all the photos of the current user and the friend with userId
 */
- (void)getFacebookPhotosWithFriend:(NSString *)userID withCompletionHandler: (void(^)(NSArray *photos, NSError *error))completion;

/*
 * Method name: logout
 * Description: Logs out the current user
 */
- (void)logout;

@end
