//
//  PointsModel.h
//  Memoriz
//
//  Created by Inian Parameshwaran on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NSString *const kMRPointClassKey;
NSString *const kMRPointUserIdKey;
NSString *const kMRPointFriendIdKey;
NSString *const kMRPointPointsKey;
NSString *const kMRPointCreateAtKey;

@interface PointModel : PFObject<PFSubclassing,NSCoding>{
}

+ (NSString *)parseClassName;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *friendID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic) NSInteger points;

@end