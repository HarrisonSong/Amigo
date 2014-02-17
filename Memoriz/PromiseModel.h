//
//  PromiseModel.h
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostModel.h"

extern NSString *const kMRPromiseContentKey;
extern NSString *const kMRPromiseDeadlineKey;
extern NSString *const kMRPromisefulfillmentKey;

@interface PromiseModel : PostModel<PFSubclassing>

@property (nonatomic, strong) NSString *promiseContent;
@property (nonatomic, strong) NSDate *promiseDeadline;
@property (nonatomic, strong) NSNumber *fulfillment;

+(NSString*)parseClassName;

@end
