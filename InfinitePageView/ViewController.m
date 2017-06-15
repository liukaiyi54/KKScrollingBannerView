//
//  ViewController.m
//  InfinitePageView
//
//  Created by Michael on 01/12/2016.
//  Copyright © 2016 Michael. All rights reserved.
//

#import "ViewController.h"
#import "MKInfinitePageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor yellowColor];
    UIView *view3 = [[UIView alloc] init];
    view3.backgroundColor = [UIColor blueColor];
    
    MKInfinitePageView *pageView = [[MKInfinitePageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200)];
    pageView.pageViews = @[view, view2];
    pageView.autoPlay = NO;
    pageView.tapHandler = ^(MKInfinitePageView *view, NSInteger index) {
        NSLog(@"Did tap index %ld", index);
    };
    
    [self.view addSubview:pageView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
