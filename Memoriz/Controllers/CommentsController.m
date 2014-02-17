//
//  CommentsController.m
//  Memoriz
//
//  Created by qiyue song on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CommentsController.h"
#import "ServerController.h"
#import "PointsController.h"

#define COMMENT_CACHE_KEY @"comment_for_post_%@"

@implementation CommentsController

+ (void)getComments:(NSString*)targetID withCompletionHandler:(void(^)(NSArray *commentsArray,NSError *error))completion{
    if ([[EGOCache globalCache] hasCacheForKey:[NSString stringWithFormat:COMMENT_CACHE_KEY, targetID]]) {
        completion((NSArray*)[[EGOCache globalCache] objectForKey:[NSString stringWithFormat:COMMENT_CACHE_KEY, targetID]], nil);
    }
    
    [ServerController queryWithClassName:kMRCommentsClassKey andConditions:@{kMRCommentsTargetKey:targetID} WithCompletionHandler:^(NSArray *objects, NSError *error) {
        if(!error){
            DDLogVerbose(@"%@: %@, %@.", THIS_FILE,THIS_METHOD, objects);
            [[EGOCache globalCache] setObject:objects forKey:[NSString stringWithFormat:COMMENT_CACHE_KEY, targetID]];
            completion(objects,nil);
        }else{
            DDLogVerbose(@"Error: %@ %@", error, [error userInfo]);
            completion(nil,error);
        }
    }];
}

+ (void)addComments:(PostModel*)post content:(NSString *)content withCompletionHandler:(void(^)(NSError *error))completion{
    CommentsModel *comment = [[CommentsModel alloc] init];
    comment.targetID = post.objectId;
    comment.content = content;
    comment.commenterUserID = [[PFUser currentUser] objectId];
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(error);
    }];
    [[PointsController sharedInstance] updatePointsWithUserID:comment.targetID forEvent:kTimeLineCommentEvent];
    post.commentCount += 1;
    
    [post saveInBackground];
}

@end
