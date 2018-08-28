//
//  ViewController.m
//  KKScrollBannerView
//
//  Created by Michael on 01/12/2016.
//  Copyright © 2016 Michael. All rights reserved.
//

#import "ViewController.h"

#import "KKScrollBannerView.h"

@interface ViewController () <BannerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *indexTextField;
@property (nonatomic, strong) KKScrollBannerView *pageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.pageView = [[KKScrollBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    self.pageView.dataSource = self;
    self.pageView.timeInterval = 4.0;
    self.pageView.scrollDirection = KKScrollBannerViewDirectionRightToLeft;
    self.pageView.showPageControl = NO;
    self.pageView.autoScroll = YES;

    [self.view addSubview:self.pageView];
}
- (IBAction)leftToRight:(UIButton *)sender {
    self.pageView.scrollDirection = KKScrollBannerViewDirectionLeftToRight;
    [self.pageView updateData];
}

- (IBAction)rightToLeft:(UIButton *)sender {
    self.pageView.scrollDirection = KKScrollBannerViewDirectionRightToLeft;
    [self.pageView updateData];
}

- (IBAction)topToBottom:(UIButton *)sender {
    self.pageView.scrollDirection = KKScrollBannerViewDirectionTopToBottom;
    [self.pageView updateData];
}

- (IBAction)bottomToTop:(UIButton *)sender {
    self.pageView.scrollDirection = KKScrollBannerViewDirectionBottomToTop;
    [self.pageView updateData];
}

- (IBAction)scrollToIndex:(UIButton *)sender {
    [self.pageView scrollToIndex:[self.indexTextField.text integerValue]];
}

#pragma mark - DataSource
- (NSArray *)bannerViews {
    UIImageView *view = [[UIImageView alloc] init];
    view.image = [UIImage imageNamed:@"01"];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 40, 14)];
    label1.text = @"1";
    label1.font = [UIFont systemFontOfSize:40];
    label1.textColor = [UIColor whiteColor];
    [label1 sizeToFit];
    [view addSubview:label1];
    
    UIImageView *view2 = [[UIImageView alloc] init];
    view2.image = [UIImage imageNamed:@"02"];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 40, 14)];
    label2.text = @"2";
    label2.font = [UIFont systemFontOfSize:40];
    label2.textColor = [UIColor whiteColor];
    [label2 sizeToFit];
    [view2 addSubview:label2];
    
    UIImageView *view3 = [[UIImageView alloc] init];
    view3.image = [UIImage imageNamed:@"03"];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 40, 14)];
    label3.text = @"3";
    label3.font = [UIFont systemFontOfSize:40];
    label3.textColor = [UIColor whiteColor];
    [label3 sizeToFit];
    [view3 addSubview:label3];
    
    return @[view, view2, view3];
}

@end
