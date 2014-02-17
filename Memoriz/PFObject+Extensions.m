//
//  PFObject+Extension.m
//  Amigo
//
//  Created by Zenan on 16/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "PFObject+Extensions.h"

@implementation PFObject (extensions)

#pragma mark - NSCoding compliance
#define kPFObjectAllKeys @"___PFObjectAllKeys"
#define kPFObjectClassName @"___PFObjectClassName"
#define kPFObjectObjectId @"___PFObjectId"
#define kPFObjectCreatedAt @"___PFObjectCreatedAt"
#define kPFACLPermissions @"permissionsById"
#define kPFObjectUpdateAt @"___PFObjectUpdatedAt"

-(void) encodeWithCoder:(NSCoder *) encoder{
    
    // Encode first className, objectId and All Keys
    [encoder encodeObject:[self parseClassName] forKey:kPFObjectClassName];
    [encoder encodeObject:[self objectId] forKey:kPFObjectObjectId];
    [encoder encodeObject:[self createdAt] forKey:kPFObjectCreatedAt];
    [encoder encodeObject:[self updatedAt] forKey:kPFObjectUpdateAt];
    [encoder encodeObject:[self allKeys] forKey:kPFObjectAllKeys];
    for (NSString * key in [self allKeys]) {
        [encoder  encodeObject:self[key] forKey:key];
    }
    
}
-(id) initWithCoder:(NSCoder *) aDecoder{
    
    // Decode the className and objectId
    NSString * aClassName  = [aDecoder decodeObjectForKey:kPFObjectClassName];
    NSString * anObjectId = [aDecoder decodeObjectForKey:kPFObjectObjectId];
    
    
    // Init the object
    self = [PFObject objectWithoutDataWithClassName:aClassName objectId:anObjectId];
    createdAt = [aDecoder decodeObjectForKey:kPFObjectCreatedAt];
    updatedAt = [aDecoder decodeObjectForKey:kPFObjectUpdateAt];
    
    if (self) {
        NSArray * allKeys = [aDecoder decodeObjectForKey:kPFObjectAllKeys];
        for (NSString * key in allKeys) {
            id obj = [aDecoder decodeObjectForKey:key];
            if (obj) {
                self[key] = obj;
            }
            
        }
    }
    return self;
}


@end

@implementation PFACL (extension)

-(void) encodeWithCoder:(NSCoder *) encoder{
    [encoder encodeObject:[self valueForKey:kPFACLPermissions] forKey:kPFACLPermissions];
}

-(id) initWithCoder:(NSCoder *) aDecoder{
    self = [super init];
    if (self) {
        [self setValue:[aDecoder decodeObjectForKey:kPFACLPermissions] forKey:kPFACLPermissions];
    }
    return self;
}

@end
