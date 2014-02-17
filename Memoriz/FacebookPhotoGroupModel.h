//
//  FacebookPhotoGroupModel.h
//  Amigo
//
//  Created by Inian Parameshwaran on 23/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostModel.h"
#import "FacebookPhotoModel.h"
#import "PostModel.h"

@interface FacebookPhotoGroupModel : NSObject <NSCoding>

@property (nonatomic, strong) NSMutableArray *facebookPhotos;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) PostType postType;

@end
