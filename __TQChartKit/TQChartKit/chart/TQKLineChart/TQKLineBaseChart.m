//
//  TQKLineBaseChart.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/26.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQKLineBaseChart.h"

@interface TQKLineBaseChart () <UIScrollViewDelegate>

@property (nonatomic, strong, readonly) UIView *contentView;

@end

@implementation TQKLineBaseChart


- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInitialization];
        [self sublayerInitialization];
        [self gestureInitialization];
    }
    return self;
}

- (void)commonInitialization {
    _contentView = [UIView new];
    [self addSubview:_contentView];
    
    _contentGridLayer = [CALayer layer];
    [_contentView.layer addSublayer:_contentGridLayer];
    
    _scrollView = [UIScrollView new];
    _scrollView.contentInset = UIEdgeInsetsZero;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.delegate = self;
    [_contentView addSubview:_scrollView];
    
    _contentChartLayer = [CALayer layer];
    [_scrollView.layer addSublayer:_contentChartLayer];
    
    _contentTextLayer = [CALayer layer];
    [_contentView.layer addSublayer:_contentTextLayer];
}

- (void)layoutSubviews {
    _scrollView.frame = self.bounds;
    _contentView.frame = self.bounds;
}

- (void)sublayerInitialization {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)gestureInitialization {
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
