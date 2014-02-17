//
//  TimelinePostModel.m
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//


#import "PostModel.h"

NSString *const kMRPostPhotoClassKey = @"PFTimeLinePhoto";
NSString *const kMRPostMessageClassKey = @"PFTimeLineMessage";
NSString *const kMRPostPromiseClassKey = @"PFTimeLinePromise";
NSString *const kMRPostEventClassKey = @"PFTimeLineEvent";
NSString *const kMRPostGameClassKey = @"PFTimeLineGame";
NSString *const kMRPostCreatedAtKey = @"createdAt";
NSString *const kMRPostCreatorUserIDKey = @"creatorUserID";
NSString *const kMRPostToUserIDKey = @"postToUserID";
NSString *const kMRPostTypeKey = @"postType";

@implementation PostModel

@dynamic commentCount;
@dynamic creatorUserID;
@dynamic postToUserID;
@dynamic postType;

- (id) newPostWithCopy
{
    PostModel *newPost = [[PostModel alloc] init];
    newPost.creatorUserID = [NSString stringWithString:self.creatorUserID];
    newPost.postToUserID = [NSString stringWithString:self.postToUserID];
    newPost.postType = self.postType;
    newPost.commentCount = self.commentCount;
    
    return newPost;
}

@end
