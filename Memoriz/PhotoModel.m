//
//  PhotoModel.m
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "PhotoModel.h"

NSString *const kMRPostPhotoPathKey = @"photoPath";

@implementation PhotoModel

@dynamic photoPath;

+(NSString*)parseClassName{
    return kMRPostPhotoClassKey;
}

-(id) newPostWithCopy
{
    PhotoModel *newPhoto = (PhotoModel*)[super newPostWithCopy];
    newPhoto.photoPath = [NSString stringWithString:self.photoPath];
    return newPhoto;
}

@end
