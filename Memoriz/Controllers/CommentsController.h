//
//  CommentsController.h
//  Memoriz
//
//  Created by qiyue song on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "CommentsModel.h"
#import "PostModel.h"


@interface CommentsController : NSObject

/*
 * Method Name: getComments
 * Descriptoin: fetch comments from parse for a specific post
 * Parameter: the objectID for the post whose comments are to be fetched
 * Parameter: the return block
 */
+ (void)getComments:(NSString*)targetID withCompletionHandler:(void(^)(NSArray *commentsArray,NSError *error))completion;

/*
 * Method Name: addComments
 * Description: add a comment to a specific post
 * Parameter: the post model to add the comment
 * Parameter: the string content for the comment
 * Parameter: the return block
 */
+ (void)addComments:(PostModel*)post content:(NSString *)content withCompletionHandler:(void(^)(NSError *error))completion;

@end
