//
//  TJWKWebViewTabController.m
//  TJWKWebViewController
//
//  Created by zhanghao on 2020/12/29.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import "TJWKWebViewTabController.h"

#pragma mark - TJWKWebPageControl

@interface TJWKWebPageControl : UIControl

@property(nonatomic, strong) CAShapeLayer *arrowLayer;

@end

@implementation TJWKWebPageControl

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _arrowLayer = [CAShapeLayer layer];
        _arrowLayer.strokeColor = [UIColor blackColor].CGColor;
        _arrowLayer.lineCap = kCALineCapRound;
        _arrowLayer.lineJoin = kCALineJoinRound;
        _arrowLayer.lineWidth = 1.5;
        [self.layer addSublayer:_arrowLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    CGRect _frame = UIEdgeInsetsInsetRect(self.bounds, insets);
    CGPoint _half = CGPointMake(_frame.size.width, _frame.size.height / 2);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(insets.left, _half.y + insets.top)];
    [path addLineToPoint:CGPointMake(_half.x + insets.left, insets.top)];
    [path moveToPoint:CGPointMake(insets.left, _half.y + insets.top)];
    [path addLineToPoint:CGPointMake(_half.x + insets.left, _frame.size.height + insets.top)];
    _arrowLayer.path = path.CGPath;
}

@end

#pragma mark - TJWKWebPageTabBar

@interface TJWKWebPageTabBar : UIView

@property (nonatomic, strong) UIColor *linesColor;
@property (nonatomic, strong) CALayer *lineLayer;
@property (nonatomic, assign) BOOL backEnabled;
@property (nonatomic, assign) BOOL forwardEnabled;
@property (nonatomic, strong) TJWKWebPageControl *backControl;
@property (nonatomic, strong) TJWKWebPageControl *forwardControl;
@property (nonatomic, weak, readonly) WKWebView *wkWebView;

@end

@implementation TJWKWebPageTabBar

- (instancetype)initWithWebView:(WKWebView *)webView {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _wkWebView = webView;
        
        _lineLayer = [CALayer layer];
        _lineLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25].CGColor;
        [self.layer addSublayer:_lineLayer];
        
        _backControl = [TJWKWebPageControl new];
        [_backControl addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backControl];
        
        _forwardControl = [TJWKWebPageControl new];
        _forwardControl.transform = CGAffineTransformRotate(_forwardControl.transform, M_PI);
        [_forwardControl addTarget:self action:@selector(forwardClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_forwardControl];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat offset = 50;
    CGRect rect = CGRectMake(0, 0, 28, 35);
    _forwardControl.frame = rect;
    _backControl.frame = rect;
    
    CGFloat centerY = self.bounds.size.height / 2;
    if (@available(iOS 11.0, *)) {
        if (self.window.safeAreaInsets.bottom > 0) centerY -= 17;
    }
    _backControl.center = CGPointMake(self.bounds.size.width / 2 - offset, centerY);
    _forwardControl.center = CGPointMake(self.bounds.size.width / 2 + offset, centerY);
    _lineLayer.frame = (CGRect){.size = CGSizeMake(self.bounds.size.width, 1 / UIScreen.mainScreen.scale)};
}

- (UIColor *)arrowColorForEnabled:(BOOL)enabled {
    if (enabled) return self.linesColor;
    return [self.linesColor colorWithAlphaComponent:0.3];
}

- (void)setBackEnabled:(BOOL)backEnabled {
    _backEnabled = backEnabled;
    _backControl.userInteractionEnabled = backEnabled;
    _backControl.arrowLayer.strokeColor = [self arrowColorForEnabled:backEnabled].CGColor;
}

- (void)setForwardEnabled:(BOOL)forwardEnabled {
    _forwardEnabled = forwardEnabled;
    _forwardControl.userInteractionEnabled = forwardEnabled;
    _forwardControl.arrowLayer.strokeColor = [self arrowColorForEnabled:forwardEnabled].CGColor;
}

- (void)backClicked {
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    }
}

- (void)forwardClicked {
    if ([self.wkWebView canGoForward]) {
        [self.wkWebView goForward];
    }
}

@end

#pragma mark - TJWKWebViewTabController

@interface TJWKWebViewTabController () <UIScrollViewDelegate>

@property (nonatomic, assign) CGPoint previousContentOffset;
@property (nonatomic, assign) BOOL pageTabbarDisplayed;
@property (nonatomic, strong) TJWKWebPageTabBar *wkPageTabBar;

@end

@implementation TJWKWebViewTabController

- (instancetype)init {
    self = [super init];
    _pageTabBarHeight = 49;
    _pageTabBarHeight += [self safeInsets].bottom;
    _pageTabBarTintColor = [UIColor blackColor];
    return self;
}

- (UIEdgeInsets)safeInsets {
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window) window = [[UIApplication sharedApplication] delegate].window;
        return window.safeAreaInsets;
    }
    return UIEdgeInsetsMake(20, 0, 0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wkWebView.scrollView.delegate = self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"canGoBack"]) {
        if ([self.wkWebView canGoBack]) {
            [self showPageTabBar];
        }
        self.wkPageTabBar.backEnabled = self.wkWebView.canGoBack;
    }
    
    if ([keyPath isEqualToString:@"canGoForward"]) {
        self.wkPageTabBar.forwardEnabled = self.wkWebView.canGoForward;
    }
    return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _previousContentOffset = scrollView.contentOffset;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.wkWebView canGoBack] || [self.wkWebView canGoForward]) {
        if (scrollView.contentOffset.y <= [self webviewScrollTop]) {
            [self showPageTabBar];
        } else if (scrollView.contentOffset.y >= [self webviewScrollBottom]) {
            [self hidePageTabBar];
        } else {
            BOOL downward = scrollView.contentOffset.y - _previousContentOffset.y > 0;
            downward ? [self hidePageTabBar] : [self showPageTabBar];
        }
    }
}

- (CGFloat)webviewScrollTop {
    return (0 - self.wkWebView.scrollView.contentInset.top);
}

- (CGFloat)webviewScrollBottom {
    return (self.wkWebView.scrollView.contentSize.height - self.wkWebView.scrollView.bounds.size.height + self.wkWebView.scrollView.contentInset.bottom);
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([self.wkWebView canGoBack] || [self.wkWebView canGoForward]) {
        [self showPageTabBar];
    }
    return [super webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
}

#pragma mark - PKWKWebPageTabBar

- (TJWKWebPageTabBar *)wkPageTabBar {
    if (!_wkPageTabBar) {
        _wkPageTabBar = [[TJWKWebPageTabBar alloc] initWithWebView:self.wkWebView];
        _wkPageTabBar.linesColor = self.pageTabBarTintColor;
        _wkPageTabBar.forwardEnabled = NO;
        [self.view addSubview:_wkPageTabBar];
    }
    return _wkPageTabBar;
}

- (void)showPageTabBar {
    if (self.pageTabbarDisplayed) return;
    self.wkPageTabBar.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.pageTabBarHeight);
    [UIView animateWithDuration:0.25 animations:^{
        CGRect _frame = self.wkPageTabBar.frame;
        _frame.origin.y = self.view.bounds.size.height - self.pageTabBarHeight;
        self.wkPageTabBar.frame = _frame;
    } completion:^(BOOL finished) {
        self.pageTabbarDisplayed = YES;
    }];
}

- (void)hidePageTabBar {
    if (!self.pageTabbarDisplayed) return;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect _frame = self.wkPageTabBar.frame;
        _frame.origin.y += _frame.size.height;
        self.wkPageTabBar.frame = _frame;
    } completion:^(BOOL finished) {
        self.pageTabbarDisplayed = NO;
    }];
}

@end
