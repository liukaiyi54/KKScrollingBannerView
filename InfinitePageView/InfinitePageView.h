//
//  InfinitePageView.h
//  InfinitePageView
//
//  Created by Michael on 15/06/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfinitePageViewDataSource <NSObject>

- (NSArray *)pageViews;

@end

@class InfinitePageView;
@protocol InfinitePageViewDelegate <NSObject>

- (void)InfinigePageView:(InfinitePageView *)pageView didSelectPageAtIndex:(NSInteger)index;

@end

@interface InfinitePageView : UIView

@property (nonatomic, assign) BOOL isAutoScroll;
@property (nonatomic, assign) NSTimeInterval scrollInterval;

@property (nonatomic, weak) id<InfinitePageViewDataSource> dataSource;
@property (nonatomic, weak) id<InfinitePageViewDelegate> delegate;

- (void)reloadData;

@end
