//
//  TQTimeBaseChart.m
//  CoreGraphics_demo
//
//  Created by zhanghao on 2018/7/6.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import "TQTimeBaseChart.h"

@interface TQTimeBaseChart ()

@property (nonatomic, strong, readonly) UIView *contentView;

@end

@implementation TQTimeBaseChart

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self commonInitialization];
        [self sublayerInitialization];
        [self gestureInitialization];
    }
    return self;
}

- (void)commonInitialization {
    _contentView = [UIView new];
    [self addSubview:_contentView];
    
    _contentChartLayer = [CALayer layer];
    [_contentView.layer addSublayer:_contentChartLayer];
    
    _contentTextLayer = [CALayer layer];
    [_contentView.layer addSublayer:_contentTextLayer];
}

- (void)layoutSubviews {
    _contentView.frame = self.bounds;
}

- (void)sublayerInitialization {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)gestureInitialization {
    [self doesNotRecognizeSelector:_cmd];
}

@end
