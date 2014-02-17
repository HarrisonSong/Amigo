//
//  FacebookPhotoGroupModel.m
//  Amigo
//
//  Created by Inian Parameshwaran on 23/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FacebookPhotoGroupModel.h"

@implementation FacebookPhotoGroupModel

@synthesize facebookPhotos;
@synthesize createdAt;
@synthesize postType;

-(id) init
{
    self = [super init];
    if(self) {
        postType = kFacebookPhotoGroupPost;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aEncoder
{
    [aEncoder encodeObject:facebookPhotos forKey:@"photos"];
    [aEncoder encodeObject:createdAt forKey:@"created"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        facebookPhotos = [aDecoder decodeObjectForKey:@"photos"];
        createdAt = [aDecoder decodeObjectForKey:@"created"];
        postType = kFacebookPhotoGroupPost;
    }
    return self;
}

@end
