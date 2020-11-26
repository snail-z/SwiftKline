//
//  PKChartGradientLayer2.m
//  PKStockCharts
//
//  Created by zhanghao on 2017/8/9.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "PKChartGradientLayer.h"

@interface PKChartGradientLayer ()

@property (nonatomic, strong) CALayer *contentLayer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation PKChartGradientLayer

- (instancetype)init {
    if (self = [super init]) {
        _animationDisabled = YES;
        [self sublayerInitialization];
    }
    return self;
}

- (void)sublayerInitialization {
    _contentLayer = [CALayer layer];
    [self addSublayer:_contentLayer];
    
    _gradientLayer =  [CAGradientLayer layer];
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
    [_contentLayer addSublayer:_gradientLayer];
    
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.fillColor = [UIColor whiteColor].CGColor;
    _maskLayer.strokeColor = [UIColor clearColor].CGColor;
    _maskLayer.lineWidth = 0;
}

- (void)setPath:(CGPathRef)path {
    _path = path;
    if (path) {
        _contentLayer.frame = self.bounds;
        _gradientLayer.frame = (CGRect){.size = _contentLayer.bounds.size};
        
        if (self.gradientClolors.count > 1) {
            NSMutableArray *CGColors = [NSMutableArray array];
            for (UIColor *obj in self.gradientClolors) {
                [CGColors addObject:(__bridge id)obj.CGColor];
            }
            _gradientLayer.colors = CGColors;
            _contentLayer.mask = _maskLayer;
            
            [self addAnimationFromPath:_maskLayer.path toPath:path];
            _maskLayer.path = path;
        } else {
            _gradientLayer.backgroundColor = self.gradientClolors.lastObject.CGColor;
            _contentLayer.mask = _maskLayer;
            _maskLayer.path = path;
        }
    } else {
        _maskLayer.path = nil;
        _contentLayer.mask = nil;
        _gradientLayer.colors = nil;
        _gradientLayer.backgroundColor = nil;
    }
}

- (void)addAnimationFromPath:(CGPathRef)fromPath toPath:(CGPathRef)toPath {
    if (!fromPath || !toPath || self.animationDisabled) return;
    UIBezierPath *originPath = [UIBezierPath bezierPathWithCGPath:fromPath];
    UIBezierPath *targetPath = [UIBezierPath bezierPathWithCGPath:toPath];
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    anim.duration = 0.15;
    anim.fromValue = (__bridge id _Nullable)(originPath.CGPath);
    anim.toValue = (__bridge id _Nullable)(targetPath.CGPath);
    anim.removedOnCompletion = YES;
    [_maskLayer addAnimation:anim forKey:nil];
}

@end
