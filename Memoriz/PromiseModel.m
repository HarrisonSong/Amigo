//
//  PromiseModel.m
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "PromiseModel.h"

NSString *const kMRPromiseContentKey = @"promiseContent";
NSString *const kMRPromiseDeadlineKey = @"promiseDeadline";
NSString *const kMRPromisefulfillmentKey = @"fulfillment";

@implementation PromiseModel

@dynamic promiseContent;
@dynamic promiseDeadline;
@dynamic fulfillment;

+(NSString*)parseClassName{
    return kMRPostPromiseClassKey;
}

- (id)newPostWithCopy
{
    PromiseModel *newPromise = (PromiseModel*)[self newPostWithCopy];
    newPromise.promiseContent = [NSString stringWithString:self.promiseContent];
    newPromise.promiseDeadline = self.promiseDeadline;
    newPromise.fulfillment = self.fulfillment;
    return newPromise;
}

@end