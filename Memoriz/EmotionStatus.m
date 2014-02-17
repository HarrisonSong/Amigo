//
//  EmotionStatus.m
//  Memoriz
//
//  Created by Zenan on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "EmotionStatus.h"
#import <Parse/PFObject+Subclass.h>
#import "PFObject+Extensions.h"

NSString *const kMREmotionStatusKey = @"EmotionStatus";
NSString *const kMREmotionStatusNumber = @"emotionNumber";
NSString *const kMREmotionStatusUserID = @"userId";

@implementation EmotionStatus

@dynamic userId;
@dynamic emotionNumber;

+ (NSString *)parseClassName {
    return kMREmotionStatusKey;
}

@end
