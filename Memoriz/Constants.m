//
//  Constants.m
//  Memoriz
//
//  Created by Nur Iman Izam on 27/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString *const IPHONE_STORYBOARD = @"iPhone";
NSString *const IPAD_STORYBOARD = @"iPad";

NSString *const OPENSANS_REGULAR = @"OpenSans";
NSString *const OPENSANS_SEMIBOLD = @"OpenSans-Semibold";
NSString *const OPENSANS_BOLD = @"OpenSans-Bold";

NSInteger const EMOTICON_NUM = 40;
NSInteger const CACHE_IMAGE_TIMEOUT = 3600;
NSInteger const PHOTOS_GROUP_TIME = 86400;

NSString *const PARSE_APPLICATION_ID = @"gGjGCPb30DYQCUgDhrcJDfYVWy34iMbtuNblKHMl";
NSString *const PARSE_CLIENT_ID = @"PPXkUxx4MuiLX3uHQMksMHusUpPVWNlFt0m7qTBr";

/**
 * Method name: keyForPath
 * Description: Strips incompatible symbols from a HTTP url to be used for EGOCache
 * Parameters: NSString
 * Returns: NSString stripped from incompatible symbols
 */
+ (NSString *)keyForPath:(NSString*)path {
    path = [path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    path = [path stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    return path;
}

/**
 * Method name: facebookProfileImageURLWithId:andCGSize:
 * Description: Provides the NSURL for profile image of user with facebookId
 * Parameters: NSString and CGSize
 * Returns: NSURL for profile image
 */
+ (NSURL *)facebookProfileImageURLWithId:(NSString*)facebookId andCGSize:(CGSize)size {
    NSString *profileUrlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=%.0f&height=%.0f",facebookId,size.width,size.height];
    return [[NSURL alloc] initWithString:profileUrlString];
}

@end

