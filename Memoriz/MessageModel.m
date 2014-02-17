//
//  MessageModel.m
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MessageModel.h"

NSString *const kMRPostMessageContentKey = @"messageContent";
NSString *const kMRPostMessageEmotionNumberKey = @"messageEmotionNumber";

@implementation MessageModel

@dynamic message;
@dynamic emotionNumber;

+(NSString*)parseClassName{
    return kMRPostMessageClassKey;
}

- (id)newPostWithCopy
{
    MessageModel *newMessage = (MessageModel*)[super newPostWithCopy];
    newMessage.message = [NSString stringWithString:self.message];
    newMessage.emotionNumber = self.emotionNumber;
    return newMessage;
}

@end
