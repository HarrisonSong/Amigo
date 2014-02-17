//
//  TimelineMessageModel.h
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostModel.h"

extern NSString *const kMRPostMessageContentKey;
extern NSString *const kMRPostMessageEmotionNumberKey;

@interface MessageModel : PostModel<PFSubclassing>

@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) NSInteger emotionNumber;

+(NSString*)parseClassName;

@end
