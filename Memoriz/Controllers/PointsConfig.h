//
//  PointsConfig.h
//  Memoriz
//
//  Created by Inian Parameshwaran on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

typedef enum {
    kTimeLinePostEvent,     //event triggered when message is posted on timeline
    kTimeLinePhotoEvent,    //event triggered when photo is posten on timeline
    kTimeLineCommentEvent,  //event triggered when comments is posted
    kPromiseEvent,          //event triggered when a promise is made
    kPromiseCompleteEvent,  //event triggered when promise is completed
    kPromiseFailEvent,      //event triggered when promised is broken
} Events;

#define TIMELINE_POST_POINTS 20
#define TIMELINE_PHOTO_POINTS 20
#define TIMELINE_POST_COMMENT 10

#define PROMISE_POST_POINTS 20
#define PROMISE_COMPLETE_POINTS 30
#define PROMISE_FAIL_POINTS -10


