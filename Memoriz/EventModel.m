//
//  EventModel.m
//  Amigo
//
//  Created by Zenan on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "EventModel.h"

NSString *const kMREventNameKey = @"name";
NSString *const kMREventDescKey = @"desc";
NSString *const kMREventStartTimeKey = @"startTime";
NSString *const kMREventEndTimeKey = @"endTime";
NSString *const kMREventLocationKey = @"location";
NSString *const kMREventFBIDKey = @"fbEventID";

@implementation EventModel

@dynamic name;
@dynamic desc;
@dynamic startTime;
@dynamic endTime;
@dynamic location;
@dynamic fbEventID;
@dynamic isGoing;

+(NSString*)parseClassName{
    return kMRPostEventClassKey;
}

- (id) newPostWithCopy
{
    EventModel *newEvent = (EventModel*)[super newPostWithCopy];
    newEvent.name = [NSString stringWithString:self.name];
    newEvent.desc = [NSString stringWithString:self.desc];
    newEvent.startTime = self.startTime;
    newEvent.endTime = self.endTime;
    newEvent.location = [NSString stringWithString:self.location];
    newEvent.fbEventID = [NSString stringWithString:self.fbEventID];
    newEvent.isGoing = self.isGoing;
    
    return newEvent;
}

@end
