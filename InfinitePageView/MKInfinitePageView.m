//
//  MKInfinitePageView.m
//  InfinitePageView
//
//  Created by Michael on 01/12/2016.
//  Copyright © 2016 Michael. All rights reserved.
//

#import "MKInfinitePageView.h"

static NSString *const kCollectionViewCell = @"kCollectionViewCell";
static const CGFloat kPageControlBottomMargin = 20;
static const NSInteger kCellItemViewTag = 1008;
static const NSTimeInterval kTimerInterval = 4.0;

@interface MKInfinitePageView() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) BOOL firstLayout;

@end

@implementation MKInfinitePageView

- (void)dealloc {
    [self removeTimer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaultValues];
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefaultValues];
        [self setupSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    self.pageControl.frame = CGRectMake(0, height - self.pageControlBottomMargin, width, 0);
    
    [self.collectionViewFlowLayout invalidateLayout];
    self.collectionViewFlowLayout.itemSize = CGSizeMake(width, height);
    self.collectionView.frame = CGRectMake(0, 0, width, height);
    
    if (self.firstLayout && self.dataSource.count > 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        self.firstLayout = NO;
    }
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCell forIndexPath:indexPath];
    UIView *view = [cell.contentView viewWithTag:kCellItemViewTag];
    if (view) {
        [view removeFromSuperview];
    }
    UIView *itemView = self.dataSource[indexPath.row];
    itemView.frame = cell.contentView.frame;
    itemView.tag = kCellItemViewTag;
    [cell.contentView addSubview:itemView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }
    if (indexPath.row > self.pageViews.count) {
        return;
    }
    
    if (self.tapHandler) {
        NSUInteger page = indexPath.row - 1;
        self.tapHandler(self, page);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrolling:) withObject:scrollView afterDelay:0.1];
    
    if (self.autoPlay) {
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kTimerInterval]];
    }
}

- (void)scrollViewDidEndScrolling:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    static CGFloat lastContentOffsetX = FLT_MIN;
    if (FLT_MIN == lastContentOffsetX) {
        lastContentOffsetX = scrollView.contentOffset.x;
        return;
    }
    
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat offset = pageWidth * self.pageViews.count;
    
    if (currentOffsetX < pageWidth && lastContentOffsetX > currentOffsetX) {
        lastContentOffsetX = currentOffsetX + offset;
        scrollView.contentOffset = (CGPoint){lastContentOffsetX, currentOffsetY};
    } else if (currentOffsetX > offset && lastContentOffsetX < currentOffsetX) {
        lastContentOffsetX = currentOffsetX - offset;
        scrollView.contentOffset = (CGPoint){lastContentOffsetX, currentOffsetY};
    } else {
        lastContentOffsetX = currentOffsetX;
    }
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = floor((lastContentOffsetX - 0.5) / width);
    
    self.currentIndex = page;
}

#pragma mark - public method
- (void)scrollToCurrentPage {
    if (self.pageViews.count <= 1) {
        return;
    }
    CGFloat offsetX = CGRectGetWidth(self.collectionView.bounds) * (self.currentIndex + 1);
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.collectionView setContentOffset:offset animated:YES];
}

#pragma mark - private methods
- (void)setupSubViews {
    [self setupCollectionView];
    [self setupPageControl];
}

- (void)setupDefaultValues {
    _pageControlBottomMargin = kPageControlBottomMargin;
    self.firstLayout = YES;
    self.autoPlay = YES;
}

- (void)setupCollectionView {
    _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionViewFlowLayout.minimumInteritemSpacing = 0;
    _collectionViewFlowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionViewFlowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.scrollsToTop = NO;
    _collectionView.bounces = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCell];
    
    [self addSubview:_collectionView];
}

- (void)setupPageControl {
    [self addSubview:self.pageControl];
}

- (void)addTimer {
    [self removeTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextPage {
    if (self.pageViews.count <= 1) {
        return;
    }
    NSInteger next = self.currentIndex + 1;
    CGFloat offsetX = CGRectGetWidth(self.collectionView.bounds) * (next + 1);
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.collectionView setContentOffset:offset];
}

#pragma mark - getters && setters 
- (void)setPageViews:(NSArray *)pageViews {
    if ([_pageViews isEqual:pageViews]) {
        return;
    }
    
    if (pageViews.count == 0) {
        return;
    } else if (pageViews.count <= 1) {
        self.collectionView.scrollEnabled = NO;
    } else {
        self.collectionView.scrollEnabled = YES;
    }
    _pageViews = [pageViews copy];
    
    if (_pageViews.count == 0) {
        self.dataSource = @[];
    } else {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:pageViews.count + 2];
        [array addObject:pageViews.lastObject];
        [array addObjectsFromArray:pageViews];
        [array addObject:pageViews.firstObject];
        self.dataSource = array;
    }
    [self.collectionView reloadData];
    self.pageControl.numberOfPages = pageViews.count;
    self.currentIndex = 0;
    if (!self.firstLayout) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem: self.currentIndex + 1 inSection: 0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    [self setNeedsLayout];
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    if (currentIndex >= self.pageViews.count || currentIndex == NSNotFound) {
        currentIndex = 0;
    }
    _currentIndex = currentIndex;
    self.pageControl.currentPage = currentIndex;
}

- (void)setPageControlBottomMargin:(CGFloat)pageControlBottomMargin {
    _pageControlBottomMargin = pageControlBottomMargin;
    
    [self setNeedsLayout];
}

- (void)setPageControlColor:(UIColor *)pageControlColor {
    _pageControlColor = pageControlColor;
    
    self.pageControl.pageIndicatorTintColor = pageControlColor;
}

- (void)setPageControlCurrentPageColor:(UIColor *)pageControlCurrentPageColor {
    _pageControlCurrentPageColor = pageControlCurrentPageColor;
    
    self.pageControl.currentPageIndicatorTintColor = pageControlCurrentPageColor;
}

- (void)setAutoPlay:(BOOL)autoPlay {
    _autoPlay = autoPlay;
    if (_autoPlay) {
        [self addTimer];
    } else {
        [self removeTimer];
    }
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
    }
    return _pageControl;
}











@end
