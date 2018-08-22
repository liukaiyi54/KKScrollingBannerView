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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KKInfinitePageView *pageView = [[KKInfinitePageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    pageView.dataSource = self;
    pageView.timeInterval = 1.0;
    [pageView reloadData];
    
    [self.view addSubview:pageView];
}

#pragma mark - InfinitePageViewDataSource
- (NSArray *)pageViews {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor yellowColor];
    UIView *view3 = [[UIView alloc] init];
    view3.backgroundColor = [UIColor blueColor];
    
    return @[view, view2, view3];
}

@end
