//
//  TQKLineLoadingView.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/26.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQKLineLoadingView.h"

@interface TQKLineLoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign, readonly) UIEdgeInsets previousContentInset;
@property (weak, nonatomic, readonly) UIScrollView *scrollView;

@end

@implementation TQKLineLoadingView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self defaultInitialization];
        [self commonInitialization];
    }
    return self;
}

- (void)defaultInitialization {
    _loadingInRect = self.frame;
    _loadState = TQKLineLoadingStateNormal;
    _manualRefresh = NO;
    _themeColor = [UIColor redColor];
}

- (void)commonInitialization {
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.hidesWhenStopped = NO;
    _indicator.color = self.themeColor;
    [self addSubview:_indicator];
    
    _textLabel = [UILabel new];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.numberOfLines = 1;
    _textLabel.font = [UIFont systemFontOfSize:12];
    _textLabel.textColor = self.themeColor;
    _textLabel.hidden = YES;
    [self addSubview:_textLabel];
}

- (void)setThemeColor:(UIColor *)themeColor {
    _textLabel.textColor = _indicator.color = _themeColor = themeColor;
}

- (void)setNormalText:(NSString *)normalText {
    _normalText = normalText;
    _indicator.hidden = normalText;
    _textLabel.hidden = !normalText;
    _textLabel.text = normalText;
}

- (CGFloat)loadingInset {
    return self.loadingInRect.size.width;
}

- (void)setLoadingInRect:(CGRect)loadingInRect {
    if (loadingInRect.size.width <= 0) {
        [self removeFromSuperview];
        return;
    }
    _loadingInRect = loadingInRect;
    [self scrollViewContentSizeDidChange:nil];
}

- (void)beginLoading {
    if (self.loadingText) _textLabel.text = self.loadingText;
    [_indicator startAnimating];
}

- (void)endLoading {
    _loadState = TQKLineLoadingStateNormal;
    self.scrollView.contentInset = self.previousContentInset;
    _textLabel.text = self.normalText;
    [_indicator stopAnimating];
}

#pragma mark - Observers

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    [self removeObservers];
    if (newSuperview) {
        _scrollView = (UIScrollView *)newSuperview;
        _scrollView.alwaysBounceHorizontal = YES;
        _previousContentInset = _scrollView.contentInset;
        [self addObservers];
    }
}

- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:@"contentSize" options:options context:nil];
}

- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    [self.superview removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self.hidden || !self.alpha || !self.userInteractionEnabled) return;
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewContentOffsetDidChange:change];
    }
    if ([keyPath isEqualToString:@"contentSize"]) {
        [self scrollViewContentSizeDidChange:change];
    }
}

- (void)_amplifyInsets {
    UIEdgeInsets inset = self.scrollView.contentInset;
    inset.left = self.loadingInRect.size.width;
    self.scrollView.contentInset = inset; // 增加滚动区域left
}

- (void)_loading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            CGPoint offset = self.scrollView.contentOffset;
            offset.x = -self.loadingInRect.size.width;
            [self.scrollView setContentOffset:offset animated:NO]; // 设置滚动位置
        } completion:^(BOOL finished) {
            [self beginLoading];
        }];
    });
    if (self.loadingCallback) self.loadingCallback(self);
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    CGFloat insetLeft = self.loadingInRect.size.width;
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    if (self.manualRefresh) {
        if (self.scrollView.isDragging) {
            if (_loadState == TQKLineLoadingStateNormal && contentOffsetX < -insetLeft) {
                _loadState = TQKLineLoadingStatePending; // 转为即将刷新状态
            } else if (_loadState == TQKLineLoadingStatePending && contentOffsetX >= -insetLeft) {
                _loadState = TQKLineLoadingStateNormal; // 转为普通状态
            } else {}
        } else { //  松手后
            if (_loadState == TQKLineLoadingStatePending) {
                _loadState = TQKLineLoadingStateLoading;
                [self _amplifyInsets];
                [self _loading];
            }
        }
    } else {
        if (_loadState == TQKLineLoadingStateNormal && contentOffsetX < -insetLeft) {
            _loadState = TQKLineLoadingStatePending;
        }
        if (_loadState == TQKLineLoadingStatePending) {
            _loadState = TQKLineLoadingStateLoading;
            [self _loading];
        }
        if (!self.scrollView.isDragging && _loadState == TQKLineLoadingStateLoading) {
            [self _amplifyInsets];
        }
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    CGRect frame = self.loadingInRect;
    frame.origin.x = -self.loadingInRect.size.width;
    self.frame = frame;
    _textLabel.frame = (CGRect){.size = CGSizeMake(self.bounds.size.width, 20)};
    CGPoint selfCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _textLabel.center = _indicator.center = selfCenter;
}
    
@end
