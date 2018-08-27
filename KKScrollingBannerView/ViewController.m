//
//  ViewController.m
//  KKScrollingBannerView
//
//  Created by Michael on 01/12/2016.
//  Copyright © 2016 Michael. All rights reserved.
//

#import "ViewController.h"

#import "KKScrollingBannerView.h"

@interface ViewController () <BannerViewDataSource>
@property (nonatomic, strong) KKScrollingBannerView *pageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.pageView = [[KKScrollingBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    self.pageView.dataSource = self;
    self.pageView.timeInterval = 1.0;
    self.pageView.scrollDirection = KKScrollingBannerViewDirectionRightToLeft;
    self.pageView.showPageControl = NO;
    self.pageView.autoScroll = YES;

    
    [self.view addSubview:self.pageView];
}
- (IBAction)leftToRight:(UIButton *)sender {
    self.pageView.scrollDirection = KKScrollingBannerViewDirectionLeftToRight;
    [self.pageView loadData];
}

- (IBAction)rightToLeft:(UIButton *)sender {
    self.pageView.scrollDirection = KKScrollingBannerViewDirectionRightToLeft;
    [self.pageView loadData];
}

- (IBAction)topToBottom:(UIButton *)sender {
    self.pageView.scrollDirection = KKScrollingBannerViewDirectionTopToBottom;
    [self.pageView loadData];
}

- (IBAction)bottomToTop:(UIButton *)sender {
    self.pageView.scrollDirection = KKScrollingBannerViewDirectionBottomToTop;
    [self.pageView loadData];
}




#pragma mark - InfinitePageViewDataSource
- (NSArray *)pageViews {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 40, 14)];
    label1.text = @"1";
    label1.font = [UIFont systemFontOfSize:40];
    [label1 sizeToFit];
    [view addSubview:label1];
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor yellowColor];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 40, 14)];
    label2.text = @"2";
    label2.font = [UIFont systemFontOfSize:40];
    [label2 sizeToFit];
    [view2 addSubview:label2];
    
    UIView *view3 = [[UIView alloc] init];
    view3.backgroundColor = [UIColor blueColor];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 40, 14)];
    label3.text = @"3";
    label3.font = [UIFont systemFontOfSize:40];
    [label3 sizeToFit];
    [view3 addSubview:label3];
    
    return @[view, view2, view3];
}

@end
