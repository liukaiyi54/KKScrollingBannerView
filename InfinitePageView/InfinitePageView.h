//
//  InfinitePageView.h
//  InfinitePageView
//
//  Created by Michael on 15/06/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfinitePageViewDataSource <NSObject>

@required
- (NSArray *)pageViews;

@end

@interface InfinitePageView : UIView

@property (nonatomic, assign) BOOL isAutoScroll;

@property (nonatomic, weak) id<InfinitePageViewDataSource> dataSource;

- (void)reloadData;

@end
