//
//  KKScrollBannerView.h
//  KKScrollBannerView
//
//  Created by Michael on 15/06/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    KKScrollBannerViewDirectionLeftToRight,
    KKScrollBannerViewDirectionRightToLeft, //default direction
    KKScrollBannerViewDirectionTopToBottom,
    KKScrollBannerViewDirectionBottomToTop
} BannerViewScrollDirection;

@class KKScrollBannerView;
@protocol BannerViewDataSource <NSObject>

@required

- (NSArray *)bannerViews;

@end

@protocol BannerViewDelegate <NSObject>

@optional

- (void)bannerView:(KKScrollBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index;

@end

@interface KKScrollBannerView : UIView

@property (nonatomic, assign) BOOL autoScroll;
@property (nonatomic, assign) BOOL showPageControl;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) BannerViewScrollDirection scrollDirection;

@property (nonatomic, weak) id<BannerViewDataSource> dataSource;

+ (instancetype)scrollBannerViewWithFrame:(CGRect)frame;

- (void)updateData;

- (void)scrollToIndex:(NSInteger)index;

@end
