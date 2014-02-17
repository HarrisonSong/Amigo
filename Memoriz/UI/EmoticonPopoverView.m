//
//  EmoticonPopoverView.m
//  Memoriz
//
//  Created by Zenan on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#define EMOTICON_WIDTH 72
#define EMOTICON_HEIGHT 72
#define NUM_EMO_PER_PAGE 8
#define NUM_EMO_PER_ROW 4
#define PAGE_WIDTH ((int)self.scrollView.frame.size.width)

#import "EmoticonPopoverView.h"

@implementation EmoticonPopoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.userInteractionEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(frame.size.width * (EMOTICON_NUM / NUM_EMO_PER_PAGE), frame.size.height);
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.numberOfPages = EMOTICON_NUM / NUM_EMO_PER_PAGE;
        self.pageControl.currentPage = 0;
        self.scrollView.delegate = self;
        self.pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        CGRect pageControlFrame = self.pageControl.frame;
        pageControlFrame.origin = CGPointMake(self.scrollView.frame.size.width / 2.0 - pageControlFrame.size.width / 2.0,
                                              self.scrollView.frame.size.height - 2.0);
        self.pageControl.frame = pageControlFrame;
        
        [self addSubview:self.scrollView];
        for (int i = 1; i <= EMOTICON_NUM; i++) {
            UIImage *emoticon = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", i]];
            UIImageView *emoticonView = [[UIImageView alloc] initWithImage:emoticon];
            CGRect frame = CGRectMake(PAGE_WIDTH * ((i - 1) / NUM_EMO_PER_PAGE) + EMOTICON_WIDTH * ((i - 1) % NUM_EMO_PER_ROW),
                                      EMOTICON_HEIGHT * (((i - 1) % NUM_EMO_PER_PAGE) / NUM_EMO_PER_ROW),
                                      EMOTICON_WIDTH,
                                      EMOTICON_HEIGHT);
            
            emoticonView.frame = frame;
            
            emoticonView.tag = i;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emoticonTapped:)];
            singleTap.numberOfTapsRequired = 1;
            singleTap.numberOfTouchesRequired = 1;
            [emoticonView addGestureRecognizer:singleTap];
            emoticonView.userInteractionEnabled = YES;
            [self.scrollView addSubview:emoticonView];
            [self insertSubview:self.pageControl aboveSubview:self.scrollView];
            
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)emoticonTapped:(UIGestureRecognizer*)gesture
{
    NSLog(@"%d emoticon", [[gesture view] tag]);
    [self.delegate emoticonSelected:[[gesture view] tag]];

}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint currentOffset = scrollView.contentOffset;
    NSInteger currentPage = currentOffset.x / scrollView.frame.size.width;
    
    self.pageControl.currentPage = currentPage;
}

@end
