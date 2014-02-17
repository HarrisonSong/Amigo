//
//  FacebookPhotoModel.h
//  Amigo
//
//  Created by Inian Parameshwaran on 23/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoModel.h"

@interface FacebookPhotoModel : NSObject <NSCoding>

@property (nonatomic, strong) NSNumber *photoId;
@property (nonatomic, strong) NSURL *bigPhotoURL;
@property (nonatomic, strong) NSURL *smallPhotoURL;
@property (nonatomic, strong) NSDate *createdAt;

@end
