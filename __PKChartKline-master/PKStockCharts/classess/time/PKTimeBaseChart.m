//
//  PKTimeBaseChart.m
//  PKChartKit
//
//  Created by zhanghao on 2017/11/27.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKTimeBaseChart.h"

@implementation PKTimeBaseChart

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _containerView = [UIView new];
        [self addSubview:_containerView];
        
        _contentChartLayer = [CALayer layer];
        [_containerView.layer addSublayer:_contentChartLayer];
        
        _contentTextLayer = [CALayer layer];
        [_containerView.layer addSublayer:_contentTextLayer];
        
        [self _defaultInitialization];
        [self _sublayerInitialization];
        [self _gestureInitialization];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
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

@end
