//
//  KKScrollBannerView.m
//
//
//  Created by Michael on 15/06/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "KKScrollBannerView.h"

#define WIDTH   self.frame.size.width
#define HEIGHT  self.frame.size.height
#define HORIZONTAL self.scrollDirection == KKScrollBannerViewDirectionLeftToRight || self.scrollDirection == KKScrollBannerViewDirectionRightToLeft
#define VERTICAL self.scrollDirection == KKScrollBannerViewDirectionTopToBottom || self.scrollDirection == KKScrollBannerViewDirectionBottomToTop

@interface KKScrollBannerView() <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *viewList;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation KKScrollBannerView

+ (instancetype)scrollBannerViewWithFrame:(CGRect)frame {
    KKScrollBannerView *bannerView = [[KKScrollBannerView alloc] initWithFrame:frame];
    return bannerView;
}

- (void)dealloc {
    [self removeTimer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupDefaultValues];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubviews];
        [self setupDefaultValues];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    [self initTimer];
}

- (void)setupDefaultValues {
    _timeInterval = 4.0;
    _scrollDirection = KKScrollBannerViewDirectionRightToLeft;
    _autoScroll = YES;
    _showPageControl = YES;
}

#pragma mark - 即将进入窗口
- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    
    [self loadData];
}

- (void)loadData {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    for (UIView *view in self.viewList) {
        [view removeFromSuperview];
    }
    [self.viewList removeAllObjects];
    
    if (self.dataSource) {
        NSInteger num = [self.dataSource bannerViews].count;
        if (num == 0) return;
        // 总视图数量等于1时在尾部增加一个首视图
        if (num == 1) {
            UIView *view = [self.dataSource bannerViews].firstObject;
            view.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
            [self.viewList addObject:view];
            [self.scrollView addSubview:view];
            self.pageControl.hidden = YES;
        } else {
            // 总视图数量大于1时，在viewList首部插入一个尾视图，再在尾部插入一个首视图，达到无限循环的目的

            switch (self.scrollDirection) {
                case KKScrollBannerViewDirectionLeftToRight: {
                    UIView *firstView = [self.dataSource bannerViews].firstObject;
                    firstView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
                    [self.viewList addObject:firstView];
                    [self.scrollView addSubview:firstView];
                    for (NSInteger i = num - 1; i >= 0; i--) {
                        UIView *view = [[self.dataSource bannerViews] objectAtIndex:i];
                        view.frame = CGRectMake((num-i) * WIDTH, 0, WIDTH, HEIGHT);
                        [self.viewList addObject:view];
                        [self.scrollView addSubview:view];
                    }
                    
                    UIView *lastView = [self.dataSource bannerViews].lastObject;
                    lastView.frame = CGRectMake((self.viewList.count) * WIDTH, 0, WIDTH, HEIGHT);
                    [self.viewList addObject:lastView];
                    [self.scrollView addSubview:lastView];
                    
                    self.scrollView.contentSize = CGSizeMake(WIDTH * self.viewList.count, HEIGHT);
                    self.scrollView.contentOffset = CGPointMake(WIDTH * num, 0);
                    break;
                }
                case KKScrollBannerViewDirectionRightToLeft: {
                    UIView *lastView = [self.dataSource bannerViews].lastObject;
                    lastView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
                    [self.viewList addObject:lastView];
                    [self.scrollView addSubview:lastView];
                    for (NSInteger i = 0; i < num; i++) {
                        UIView *view = [[self.dataSource bannerViews] objectAtIndex:i];
                        view.frame = CGRectMake((i+1) * WIDTH, 0, WIDTH, HEIGHT);
                        [self.viewList addObject:view];
                        [self.scrollView addSubview:view];
                    }
                    
                    UIView *firstView = [self.dataSource bannerViews].firstObject;
                    firstView.frame = CGRectMake((self.viewList.count) * WIDTH, 0, WIDTH, HEIGHT);
                    [self.viewList addObject:firstView];
                    [self.scrollView addSubview:firstView];
                    
                    self.scrollView.contentSize = CGSizeMake(WIDTH * self.viewList.count, HEIGHT);
                    self.scrollView.contentOffset = CGPointMake(WIDTH, 0);
                    break;
                }
                case KKScrollBannerViewDirectionTopToBottom: {
                    UIView *firstView = [self.dataSource bannerViews].firstObject;
                    firstView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
                    [self.viewList addObject:firstView];
                    [self.scrollView addSubview:firstView];
                    for (NSInteger i = num - 1; i >= 0; i--) {
                        UIView *view = [[self.dataSource bannerViews] objectAtIndex:i];
                        view.frame = CGRectMake(0, (num-i) * HEIGHT, WIDTH, HEIGHT);
                        [self.viewList addObject:view];
                        [self.scrollView addSubview:view];
                    }
                    
                    UIView *lastView = [self.dataSource bannerViews].lastObject;
                    lastView.frame = CGRectMake(0, self.viewList.count * HEIGHT, WIDTH, HEIGHT);
                    [self.viewList addObject:lastView];
                    [self.scrollView addSubview:lastView];
                    
                    self.scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT * self.viewList.count);
                    self.scrollView.contentOffset = CGPointMake(0, HEIGHT * num);
                    
                    break;
                }
                case KKScrollBannerViewDirectionBottomToTop: {
                    UIView *lastView = [self.dataSource bannerViews].lastObject;
                    lastView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
                    [self.viewList addObject:lastView];
                    [self.scrollView addSubview:lastView];
                    for (NSInteger i = 0; i < num; i++) {
                        UIView *view = [[self.dataSource bannerViews] objectAtIndex:i];
                        view.frame = CGRectMake(0, (i+1) * HEIGHT, WIDTH, HEIGHT);
                        [self.viewList addObject:view];
                        [self.scrollView addSubview:view];
                    }
                    
                    UIView *firstView = [self.dataSource bannerViews].firstObject;
                    firstView.frame = CGRectMake(0, (self.viewList.count) * HEIGHT, WIDTH, HEIGHT);
                    [self.viewList addObject:firstView];
                    [self.scrollView addSubview:firstView];
                    
                    self.scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT * self.viewList.count);
                    self.scrollView.contentOffset = CGPointMake(0, HEIGHT);
                    break;
                }
                default:
                    break;
            }
            
            self.pageControl.numberOfPages = num;
        }
    }
}

- (void)scrollTheView {
    if ([self.dataSource bannerViews].count <= 1) return;
    
    [UIView animateWithDuration:0.5 animations:^{
        switch (self.scrollDirection) {
            case KKScrollBannerViewDirectionLeftToRight: {
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x - WIDTH, 0);
                break;
            }
            case KKScrollBannerViewDirectionRightToLeft: {
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + WIDTH, 0);
                break;
            }
            case KKScrollBannerViewDirectionTopToBottom: {
                self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentOffset.y - HEIGHT);
                break;
            }
            case KKScrollBannerViewDirectionBottomToTop: {
                self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentOffset.y + HEIGHT);
                break;
            }
            default:
                break;
        }
    }];
    [self scrollViewDidEndDecelerating:self.scrollView];
}

- (void)initTimer {
    [self removeTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(scrollTheView) userInfo:nil repeats:YES];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (HORIZONTAL) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    } else {
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    
    if (HORIZONTAL) {
        if (width == 0) return;
    } else {
        if (height == 0) return;
    }
    
    NSInteger index = scrollView.contentOffset.x / width;
    if (VERTICAL) {
        index = scrollView.contentOffset.y / height;
    }
    if (index == 0) {
        if (HORIZONTAL) {
            scrollView.contentOffset = CGPointMake(width * (self.viewList.count - 2), 0);
        } else {
            scrollView.contentOffset = CGPointMake(0, height * (self.viewList.count - 2));
        }
        self.pageControl.currentPage = self.viewList.count - 2;
    } else if (index == self.viewList.count - 1) {
        if (HORIZONTAL) {
            if (self.scrollDirection == KKScrollBannerViewDirectionLeftToRight) {
                scrollView.contentOffset = CGPointMake(width * [self.dataSource bannerViews].count, 0);
            } else {
                scrollView.contentOffset = CGPointMake(width, 0);
            }
        } else {
            scrollView.contentOffset = CGPointMake(0, height);
        }
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = index - 1;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.timer.tolerance = INFINITY;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.timer.tolerance = self.timeInterval;
}

#pragma mark - setters & getters
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.bounds;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(WIDTH/2- 40, HEIGHT - 20, 80, 20);
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

- (NSMutableArray *)viewList {
    if (!_viewList) {
        _viewList = [[NSMutableArray alloc] init];
    }
    return _viewList;
}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    if (_autoScroll) {
        [self initTimer];
    } else {
        [self removeTimer];
    }
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
    if (_timeInterval > 0) {
        [self removeTimer];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(scrollTheView) userInfo:nil repeats:YES];
    }
}

- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    if (_showPageControl) {
        self.pageControl.hidden = NO;
    } else {
        self.pageControl.hidden = YES;
    }
}

@end
