//
//  InfinitePageView.m
//  InfinitePageView
//
//  Created by Michael on 15/06/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "InfinitePageView.h"

static const NSTimeInterval kTimerInterval = 4.0;

@interface InfinitePageView() <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *viewList;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation InfinitePageView

- (void)dealloc {
    [self removeTimer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    [self initTimer];
}

- (void)reloadData {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    for (UIView *view in self.viewList) {
        [view removeFromSuperview];
    }
    [self.viewList removeAllObjects];
    
    if (self.dataSource) {
        NSInteger num = [self.dataSource pageViews].count;
        if (num == 0) return;
        if (num == 1) {
            UIView *view = [self.dataSource pageViews].firstObject;
            view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            [self.viewList addObject:view];
            [self.scrollView addSubview:view];
            self.pageControl.hidden = YES;
        } else {
            UIView *lastView = [self.dataSource pageViews].lastObject;
            lastView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            [self.viewList addObject:lastView];
            [self.scrollView addSubview:lastView];
            
            for (NSInteger i = 0; i < num; i++) {
                UIView *view = [[self.dataSource pageViews] objectAtIndex:i];
                view.frame = CGRectMake((i+1) * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                [self.viewList addObject:view];
                [self.scrollView addSubview:view];
            }
            
            UIView *firstView = [self.dataSource pageViews].firstObject;
            firstView.frame = CGRectMake((self.viewList.count) * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            [self.viewList addObject:firstView];
            [self.scrollView addSubview:firstView];
            
            self.scrollView.contentSize = CGSizeMake(self.frame.size.width * self.viewList.count, self.frame.size.height);
            self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
            
            self.pageControl.hidden = NO;
            self.pageControl.numberOfPages = num;
        }
    }
}

- (void)scrollTheView {
    if ([self.dataSource pageViews].count <= 1) return;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + self.frame.size.width, 0);
    }];
    [self scrollViewDidEndDecelerating:self.scrollView];
}

- (void)initTimer {
    [self removeTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(scrollTheView) userInfo:nil repeats:YES];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.frame.size.width == 0) return;
    
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (index == 0) {
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * (self.viewList.count - 2), 0);
        self.pageControl.currentPage = self.viewList.count - 2;
    } else if (index == self.viewList.count - 1) {
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = index - 1;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.timer.tolerance = INFINITY;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.timer.tolerance = kTimerInterval;
}

#pragma mark - setters & getters
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.frame;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(self.frame.size.width/2- 40, self.frame.size.height - 20, 80, 20);
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.hidden = NO;
    }
    return _pageControl;
}

- (NSMutableArray *)viewList {
    if (!_viewList) {
        _viewList = [[NSMutableArray alloc] init];
    }
    return _viewList;
}

- (void)setIsAutoScroll:(BOOL)isAutoScroll {
    _isAutoScroll = isAutoScroll;
    if (_isAutoScroll) {
        [self initTimer];
    } else {
        [self removeTimer];
    }
}

@end
