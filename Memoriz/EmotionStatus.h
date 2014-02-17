//
//  EmotionStatus.h
//  Memoriz
//
//  Created by Zenan on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NSString *const kMREmotionStatusKey;
NSString *const kMREmotionStatusNumber;
NSString *const kMREmotionStatusUserID;

@interface EmotionStatus : PFObject<PFSubclassing, NSCoding>{
    
}

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, assign) NSInteger emotionNumber;

+ (NSString *)parseClassName;

@end
