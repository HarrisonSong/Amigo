//
//  ServerController.h
//  Memoriz
//
//  Created by Inian Parameshwaran on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "S3Controller.h"
@interface ServerController : NSObject

extern NSString * const kCacheConstraint;
extern NSString * const kLimitConstraint;
extern NSString * const kOffsetConstraint;
extern NSString * const kCountQueryConstraint;

@property (nonatomic, strong) S3Controller *s3Controller;
@property (nonatomic, strong) NSMutableDictionary *imageDictionary;

// Singleton
+ (ServerController *)sharedInstance;

/*
 * Description: Setting up the ServerController upon Application launch
 * Parameters: NSDictionary containing the launchOptions
 */
- (void) setupServerControllerWithLaunchOptions:(NSDictionary*)launchOptions;

/*
 * Description: Stores the current installation data of the device on the server
 * Parameters: the device token of the device
 */
- (void) registerNotificationForDeviceWithToken:(NSData *)deviceToken;

/*
 * Description: Handles a push notification when the application is running
 * Parameters: NSDictionary containing the user information
 */
- (void) receiveRemoteNotificationForDeviceWithToken:(NSDictionary *)userInfo;

/*
 * Description: Associates the current user with installation data
 */
- (void) attachUserToInstallation;

/*
 * Description: This method sends push notification to the given users
                The format of the data array -
                alert - The message to be sent in the push notification
                badge - The badge number to be shown
 * Parameter: The users to which the push notification is to be sent
 * Parameter: The data to be used in the above format
 */
- (void) sendPushNotificationToUsers: (NSArray *)userModels withData:(NSDictionary *)data;

/*
 * Description: This methods resets the badge count of the application
 */
- (void) resetBadgeCount;

/*
 * Description: The method queries the database. The query returns the records where the
                keys and values of the conditions dictionary are used to query the columns of the table
                The results are returned with the help of the completion handler.
 * Parameter: The type of the class to be queried
 * Parameter: The completion handler
 */
+ (void) queryWithClassName:(NSString *) type andConditions:(NSDictionary *) conditions WithCompletionHandler: (void(^)(NSArray *results, NSError *error))completion;

/*
 * Description: The method queries the database. The query returns the records where the
                keys and values of the conditions dictionary are used to query the columns of the table.
                Possible values in constraint dictionary
                kCacheConstraint - the caching policy of the query
                kLimitConstraint - the limit on the number of records to be returned
                kOffsetConstraint - the offset from the start of the query
                kCountQueryConstraint - only the number of records are returned
                The results are returned with the help of the completion handler.
  * Parameter: The type of class to be queried
  * Parameter: The conditions for the query
  * Parameter: The constraints with the format described above
  * Parameter: The completion handler
 */
+(void) queryWithClassName:(NSString *)type andConditions:(NSDictionary *)conditions andConstraints:(NSDictionary *)constraints WithCompletionHandler:(void (^)(NSArray *, NSError *))completion;

/*
 * Description: The method queries the database. The query returns the records where the
                keys and values of the conditions dictionary are used to query the columns of the table.
                The cache policy of the query function can also be specified in this function.
                The results are returned with the help of the completion handler.
  * Parameter: The type of the class to be queried
  * Parameter: The conditions for the query
  * Parameter: The cache policy for the query
 */
+ (void) queryWithClassName:(NSString *)type andConditions:(NSDictionary *)conditions andCachePolicy:(BOOL) cachePolicy WithCompletionHandler:(void (^)(NSArray *, NSError *))completion;

/*
 * Description: The query is used to search for users with conditions and the results
                are returned to the completion handler
 * Parameter: The conditions for the query
 * Parameter: The completion handler
 */
+ (void) queryUserWithConditions:(NSDictionary *) conditions andCompletionHandler: (void(^)(NSArray *results, NSError *error))completion;

/*
 * Description: This query returns the users based on the conditions
 *              The cache policy can also be specified in this function.
 * Parameter: The conditions used for the query
 * Parameter: The cache policy for the query
 * Parameter: The completion handler
 */
+ (void) queryUserWithConditions:(NSDictionary *) conditions andCachePolicy:(BOOL)cachePolicy andCompletionHandler: (void(^)(NSArray *results, NSError *error))completion;

/*
 * Description: This method requests for the URL and returns the JSON response in the completion handler
 * Parameter: The URL to be requested
 * Parameter: The completion handler
 */
+ (void) requestJSON:(NSURL *) url WithCompletionHandler: (void(^)(id response, NSError *error))completion;

/*
 * Description: This function sends a welcome email to the following mail id
 * Parameter: The mail Id to send the mail to 
 */
+ (void) sendWelcomeEmailToId:(NSString *) mail;
@end
