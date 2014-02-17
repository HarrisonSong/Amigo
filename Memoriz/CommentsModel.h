//
//  CommentsModel.h
//  Memoriz
//
//  Created by qiyue song on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Parse/Parse.h>


extern NSString *const kMRCommentsClassKey;
extern NSString *const kMRCommentsFriendKey;
extern NSString *const kMRCommentsUserKey;
extern NSString *const KMRCommentsContentKey;
extern NSString *const kMRCommentsTargetKey;

@interface CommentsModel : PFObject <PFSubclassing, NSCoding> {
    
}

+(NSString *)parseClassName;
@property (nonatomic, strong) NSString *commenterUserID;
@property (nonatomic, strong) NSString *targetID;
@property (nonatomic, strong) NSString *content;

@end
