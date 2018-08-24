//
//  ViewController.m
//  KKInfinitePageView
//
//  Created by Michael on 01/12/2016.
//  Copyright © 2016 Michael. All rights reserved.
//

#import "ViewController.h"

#import "KKInfinitePageView.h"

@interface ViewController () <InfinitePageViewDataSource>
@property (nonatomic, strong) KKInfinitePageView *pageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.pageView = [[KKInfinitePageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    self.pageView.dataSource = self;
    self.pageView.timeInterval = 1.0;
    self.pageView.direction = PageViewDirectionLeftToRight;
    self.pageView.showPageControl = NO;
    self.pageView.isAutoScroll = YES;

    
    [self.view addSubview:self.pageView];
}
- (IBAction)leftToRight:(UIButton *)sender {
    self.pageView.direction = PageViewDirectionLeftToRight;
    [self.pageView loadData];
}

- (IBAction)rightToLeft:(UIButton *)sender {
    self.pageView.direction = PageViewDirectionRightToLeft;
    [self.pageView loadData];
}

- (IBAction)topToBottom:(UIButton *)sender {
    self.pageView.direction = PageViewDirectionTopToBottom;
    [self.pageView loadData];
}

- (IBAction)bottomToTop:(UIButton *)sender {
    self.pageView.direction = PageViewDirectionBottomToTop;
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
