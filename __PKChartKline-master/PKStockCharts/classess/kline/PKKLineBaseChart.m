//
//  PKKLineBaseChart.m
//  PKChartKit
//
//  Created by zhanghao on 2017/12/06.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKKLineBaseChart.h"

@interface PKKLineBaseChart () <UIScrollViewDelegate>

@end

@implementation PKKLineBaseChart

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _containerView = [UIView new];
        [self addSubview:_containerView];
        
        _contentGridLayer = [CALayer layer];
        [_containerView.layer addSublayer:_contentGridLayer];
        
        _scrollView = [UIScrollView new];
        _scrollView.contentInset = UIEdgeInsetsZero;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = NO;
        [_containerView addSubview:_scrollView];
        
        _contentChartLayer = [CALayer layer];
        [_scrollView.layer addSublayer:_contentChartLayer];
        
        _contentTextLayer = [CALayer layer];
        [_containerView.layer addSublayer:_contentTextLayer];
        
        _contentTopCahrtLayer = [CALayer layer];
        [_scrollView.layer addSublayer:_contentTopCahrtLayer];
        
        [self _defaultInitialization];
        [self _sublayerInitialization];
        [self _gestureInitialization];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
    _containerView.frame = self.bounds;
}

- (void)_defaultInitialization {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)_sublayerInitialization {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)_gestureInitialization {
    [self doesNotRecognizeSelector:_cmd];
}

- (CGFloat)maxScrollOffsetX {
    return self.scrollView.contentSize.width + self.scrollView.contentInset.right - self.scrollView.bounds.size.width;
}

- (CGFloat)minScrollOffsetX {
    return -self.scrollView.contentInset.left;
}

- (void)scrollToLeft {
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x = self.minScrollOffsetX;
    [_scrollView setContentOffset:contentOffset animated:NO];
}

- (void)scrollToRight {
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x = self.maxScrollOffsetX;
    [_scrollView setContentOffset:contentOffset animated:NO];
}

@end
