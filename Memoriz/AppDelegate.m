//
//  AppDelegate.m
//  Memoriz
//
//  Created by Nur Iman Izam on 21/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AppDelegate.h"
#import "PromiseController.h"
#import "UserController.h"
#import <AWSiOSSDK/AmazonLogger.h>
#import <AWSiOSSDK/AmazonErrorHandler.h>
#import "TimelineViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self customizeAppearance];
    
    // Add Logging Framework
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // Logging Control - Do NOT use logging for non-development builds.
#ifdef DEBUG
    [AmazonLogger verboseLogging];
#else
    [AmazonLogger turnLoggingOff];
#endif
    
    //[[EGOCache globalCache] clearCache];

    
    [AmazonErrorHandler shouldNotThrowExceptions];
    [[ServerController sharedInstance] setupServerControllerWithLaunchOptions:launchOptions];
    
    //register for push notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    // Check if already logged in
    if ([[UserController sharedInstance] isLoggedIn]) {
       
        if (IS_IPAD()) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:IPAD_STORYBOARD bundle:[NSBundle mainBundle]];
            [self.window setRootViewController:[storyBoard instantiateViewControllerWithIdentifier:@"SplitView"]];
        } else {
             UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:IPHONE_STORYBOARD bundle:[NSBundle mainBundle]];
            [self.window setRootViewController:[storyBoard instantiateViewControllerWithIdentifier:@"SliderView"]];
        }
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[FBSession activeSession] handleDidBecomeActive];
    
    [[ServerController sharedInstance] resetBadgeCount];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Push notification registration

-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[ServerController sharedInstance] registerNotificationForDeviceWithToken:deviceToken];
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[ServerController sharedInstance] receiveRemoteNotificationForDeviceWithToken:userInfo];
}

-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error registering for push notifications %@", [error localizedDescription]);
}

#pragma mark - AppDelegate Functions for Facebook

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

#pragma mark - Helper Functions

- (void)customizeAppearance {
    
    if (IS_IPAD()) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-ipad"] forBarMetrics:UIBarMetricsDefault];
    } else {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      UITextAttributeTextColor,
      [UIColor darkGrayColor],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(1, 1)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:OPENSANS_BOLD size:19.0f],
      UITextAttributeFont,
      nil]];
    
    // Remove shadow from iOS6.0
    UINavigationBar *navBar = [[UINavigationBar alloc] init];
    if ([navBar respondsToSelector:@selector(shadowImage)])
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}

@end
