//
//  EventModel.h
//  Amigo
//
//  Created by Zenan on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostModel.h"

extern NSString *const kMREventNameKey;
extern NSString *const kMREventDescKey;
extern NSString *const kMREventStartTimeKey;
extern NSString *const kMREventEndTimeKey;
extern NSString *const kMREventLocationKey;
extern NSString *const kMREventFBIDKey;


@interface EventModel : PostModel<PFSubclassing>

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *desc;
@property(nonatomic, strong) NSDate *startTime;
@property(nonatomic, strong) NSDate *endTime;
@property(nonatomic, strong) NSString *location;
@property(nonatomic, strong) NSString *fbEventID;
@property(nonatomic, assign) BOOL isGoing;

+(NSString*)parseClassName;

@end
