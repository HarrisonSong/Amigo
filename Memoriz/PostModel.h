//
//  TimelinePostModel.h
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "PFObject+Extensions.h"

extern NSString *const kMRPostPhotoClassKey;
extern NSString *const kMRPostMessageClassKey;
extern NSString *const kMRPostPromiseClassKey;
extern NSString *const kMRPostGameClassKey;
extern NSString *const kMRPostEventClassKey;
extern NSString *const kMRPostCreatedAtKey;
extern NSString *const kMRPostCreatorUserIDKey;
extern NSString *const kMRPostToUserIDKey;
extern NSString *const kMRPostTypeKey;

typedef enum {
    kPhotoPost = 0,
    kFacebookPhotoGroupPost = 5,
    kMessagePost = 1,
    kPromisePost = 2,
    kGamePost = 3,
    kEventPost = 4
} PostType;

@protocol PostCopying

- (id)newPostWithCopy;

@end

@interface PostModel : PFObject <PostCopying, NSCoding>{
}


@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSString *creatorUserID;
@property (nonatomic, strong) NSString *postToUserID;
@property (nonatomic, assign) PostType postType;

@end
