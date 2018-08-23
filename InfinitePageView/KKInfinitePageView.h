//
//  KKInfinitePageView.h
//  KKInfinitePageView
//
//  Created by Michael on 15/06/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PageViewDirectionHorizontal,
    PageViewDirectionVertical,
} PageViewDirection;

@protocol InfinitePageViewDataSource <NSObject>

@required
- (NSArray *)pageViews;

@end

@interface KKInfinitePageView : UIView

@property (nonatomic, assign) BOOL isAutoScroll;
@property (nonatomic, assign) BOOL showPageControl;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) PageViewDirection direction;

@property (nonatomic, weak) id<InfinitePageViewDataSource> dataSource;

- (void)loadData;

@end
