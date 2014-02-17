//
//  FriendsViewController.h
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsTableViewCell.h"
#import "FriendRequestTableViewCell.h"
#import "FriendInvitationTableViewCell.h"
#import "MenuTableViewCell.h"

typedef enum {
    kFriendsMenuTypeOthers,
    kFriendsMenuTypeRequests,
    kFriendsMenuTypeInvitations,
    kFriendsMenuTypeFriends,
    kFriendsMenuTypeCount
} kFriendsMenuType;

typedef enum {
    kFriendsiPadMenuTypeOthersTypeHome,
    kFriendsiPadMenuTypeOthersTypeProfile,
    kFriendsiPadMenuTypeOthersTypeHelp,
    kFriendsiPadMenuTypeOthersTypeLogout,
    kFriendsiPadMenuTypeOthersTypeInvite,
    kFriendsiPadMenuTypeOthersTypeCount
} kFriendsiPadMenuTypeOthersType;

/**
 * This is the friends view class when the slider view is swiped.
 * It shall display friends that have been added/approved
 * as well as options etc.
 */
@interface FriendsViewController : UITableViewController <FriendRequestTableViewCellDelgate, FriendInvitationTableViewCellDelgate, UIActionSheetDelegate>

@end
