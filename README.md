# KKScrollBannerView
![jun-16-2017 22-42-26](https://user-images.githubusercontent.com/3932207/44644880-31fe2680-aa08-11e8-958f-0ba12931f5eb.gif)

# A very handy scroll banner view. 

## Usage

1. Copy `KKScrollBannerView.h` and `KKScrollBannerView.m` to your project.
2. Set up in your views like this: 
```  
KKScrollBannerView *bannerView = [[KKScrollBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
bannerView.dataSource = self;

[self.view addSubview:bannerView];
```
3. Set up dataSource:
```
#pragma mark - DataSource
- (NSArray *)bannerViews {
    UIView *view0 = [[UIView alloc] init];
    UIView *view1 = [[UIView alloc] init];
    UIView *view2 = [[UIView alloc] init];
    ...
    return @[view0, view1, view2];
}

```
4. You are good to go.
