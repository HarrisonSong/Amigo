//
//  MenuViewController.h
//  Memoriz
//
//  Created by Nur Iman Izam Othman on 19/3/13.
//  Copyright (c) 2013 imanism. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"

typedef enum {
    kMenuSectionOthers,
    kMenuSectionCount
} kMenuSection;

typedef enum {
    kOthersSectionTypeHome,
    kOthersSectionTypeProfile,
    kOthersSectionTypeHelp,
    kOthersSectionTypeLogout,
    kOthersSectionTypeCount
} kOthersSectionType;

/**
 * This is the menu class when the slider view is swiped.
 * It shall display friends that have been added/approved
 * as well as options etc.
 */
@interface MenuViewController : UITableViewController <UIActionSheetDelegate>

@end
