# InfinitePageView
![jun-16-2017 22-42-26](https://user-images.githubusercontent.com/3932207/27231498-61c41c38-52e5-11e7-9df8-bb2c89893b86.gif)

# A very handy infinite page view.

## Usage

1. Copy `InfinitePageView.h` and `InfinitePageView.m` to your project.
2. Set up in your views like this: 
```  
InfinitePageView *pageView = [[InfinitePageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
pageView.dataSource = self;
[pageView reloadData];

[self.view addSubview:pageView];

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

```
3. You are good to go.
