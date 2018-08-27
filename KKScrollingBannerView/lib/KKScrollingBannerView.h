//
//  KKScrollingBannerView.h
//  KKScrollingBannerView
//
//  Created by Michael on 15/06/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    KKScrollingBannerViewDirectionLeftToRight,
    KKScrollingBannerViewDirectionRightToLeft, //default direction
    KKScrollingBannerViewDirectionTopToBottom,
    KKScrollingBannerViewDirectionBottomToTop
} BannerViewScrollDirection;

@protocol BannerViewDataSource <NSObject>

@required

- (NSArray *)pageViews;

@end

@interface KKScrollingBannerView : UIView

@property (nonatomic, assign) BOOL autoScroll;
@property (nonatomic, assign) BOOL showPageControl;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) BannerViewScrollDirection scrollDirection;

@property (nonatomic, weak) id<BannerViewDataSource> dataSource;

+ (instancetype)scrollingBannerViewWithFrame:(CGRect)frame;

- (void)loadData;

@end
