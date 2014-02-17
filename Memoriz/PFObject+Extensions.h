//
//  PFObject+Extensions.h
//  Amigo
//
//  Created by Zenan on 16/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Parse/PFObject.h>

@interface PFObject (extensions) <NSCoding>

- (void) encodeWithCoder:(NSCoder *)aCoder;

- (id) initWithCoder:(NSCoder *)aDecoder;

@end

@interface PFACL (extensions) <NSCoding>

- (void) encodeWithCoder:(NSCoder *)aCoder;

- (id) initWithCoder:(NSCoder *)aDecoder;

@end
