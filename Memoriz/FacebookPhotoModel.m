//
//  FacebookPhotoModel.m
//  Amigo
//
//  Created by Inian Parameshwaran on 23/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FacebookPhotoModel.h"

@implementation FacebookPhotoModel

@synthesize photoId;
@synthesize bigPhotoURL;
@synthesize smallPhotoURL;
@synthesize createdAt;

- (void) encodeWithCoder:(NSCoder *)aEncoder
{
    [aEncoder encodeObject:photoId forKey:@"photoId"];
    [aEncoder encodeObject:bigPhotoURL forKey:@"bigphotoURL"];
    [aEncoder encodeObject:smallPhotoURL forKey:@"smallphotoURL"];
    [aEncoder encodeObject:createdAt forKey:@"createdAt"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        photoId = [aDecoder decodeObjectForKey:@"photoId"];
        smallPhotoURL = [aDecoder decodeObjectForKey:@"smallphotoURL"];
        bigPhotoURL = [aDecoder decodeObjectForKey:@"bigphotoURL"];
        createdAt = [aDecoder decodeObjectForKey:@"createdAt"];
    }
    return self;
}


@end
