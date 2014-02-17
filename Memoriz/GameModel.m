//
//  GameModel.m
//  Memoriz
//
//  Created by Zenan on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameModel.h"

NSString *const kMRGameTitleKey = @"gameTitle";
NSString *const kMRGameMyScoreKey = @"myScore";
NSString *const kMRGameFriendScoreKey = @"friendScore";

@implementation GameModel

@dynamic gameTitle;
@dynamic myGameScore;
@dynamic friendScore;

+(NSString*)parseClassName{
    return kMRPostGameClassKey;
}

- (id) newPostWithCopy
{
    GameModel *newGame = (GameModel*)[self newPostWithCopy];
    
    return newGame;
}

@end
