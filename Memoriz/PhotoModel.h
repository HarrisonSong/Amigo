//
//  TimelinePhotoModel.h
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostModel.h"

extern NSString *const kMRPostPhotoPathKey;

@interface PhotoModel : PostModel<PFSubclassing>

@property (nonatomic, strong) NSString *photoPath;

+(NSString*)parseClassName;

@end
