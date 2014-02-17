//
//  EmoticonPopoverView.h
//  Memoriz
//
//  Created by Zenan on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmoticonPopoverDelegate

- (void)emoticonSelected:(NSInteger)emoticonNumber;

@end

@interface EmoticonPopoverView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<EmoticonPopoverDelegate> delegate;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@end
