//
//  MKInfinitePageView.h
//  InfinitePageView
//
//  Created by Michael on 01/12/2016.
//  Copyright © 2016 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKInfinitePageView;
typedef void(^MKInfinitePageViewTapHandler)(MKInfinitePageView *view, NSInteger index);

@interface MKInfinitePageView : UIView

@property (nonatomic, copy) NSArray *pageViews;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) BOOL autoPlay;
@property (nonatomic, strong) MKInfinitePageViewTapHandler tapHandler;
@property (nonatomic, strong) UIColor *pageControlCurrentPageColor;
@property (nonatomic, strong) UIColor *pageControlColor;
@property (nonatomic, assign) NSTimeInterval timerInterval;
@property (nonatomic, assign) CGFloat pageControlBottomMargin;

- (void)scrollToCurrentPage;

@end
