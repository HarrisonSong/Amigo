//
//  Constants.h
//  Memoriz
//
//  Created by Nur Iman Izam on 27/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "SVProgressHUD.h"
#import "EGOCache.h"

/* 
 
This class is already #imported in Memoriz-Prefix.pch
which is included for all classes to access
 
*/

// Storyboards
extern NSString *const IPHONE_STORYBOARD;
extern NSString *const IPAD_STORYBOARD;

// Fonts
extern NSString *const OPENSANS_REGULAR;
extern NSString *const OPENSANS_SEMIBOLD;
extern NSString *const OPENSANS_BOLD;

// Determining iPhone vs. iPad
#ifdef UI_USER_INTERFACE_IDIOM
    #define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif

// Logging Level
#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

// Emotions Count
extern NSInteger const EMOTICON_NUM;

// S3 Cache Timeout
extern NSInteger const CACHE_IMAGE_TIMEOUT;

// Facebook Photos Grouping
extern NSInteger const PHOTOS_GROUP_TIME;

// Parse details
extern NSString *const PARSE_APPLICATION_ID;
extern NSString *const PARSE_CLIENT_ID;

@interface Constants : NSObject

/**
 * Method name: keyForPath
 * Description: Strips incompatible symbols from a HTTP url to be used for EGOCache
 * Parameters: NSString
 * Returns: NSString stripped from incompatible symbols
 */
+ (NSString *)keyForPath:(NSString*)path;

/**
 * Method name: facebookProfileImageURLWithId:andCGSize:
 * Description: Provides the NSURL for profile image of user with facebookId
 * Parameters: NSString and CGSize
 * Returns: NSURL for profile image
 */
+ (NSURL *)facebookProfileImageURLWithId:(NSString*)facebookId andCGSize:(CGSize)size;

@end
