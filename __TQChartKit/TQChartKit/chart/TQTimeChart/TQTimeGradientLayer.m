//
//  TQTimeGradientLayer.m
//  CoreGraphics_demo
//
//  Created by zhanghao on 2018/7/13.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import "TQTimeGradientLayer.h"
#import "NSArray+TQChart.h"

@interface TQTimeGradientLayer ()

@property (nonatomic, strong) CALayer *contentLayer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation TQTimeGradientLayer

- (instancetype)init {
    if (self = [super init]) {
        _animationDisable = YES;
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
    if (!path) return;
    _path = path;
    _contentLayer.frame = self.bounds;
    _gradientLayer.frame = (CGRect){.size = _contentLayer.bounds.size};
    _gradientLayer.colors = self.gradientClolors.tq_toCGColors;
    _contentLayer.mask = _maskLayer;
    
    [self addAnimationFromPath:_maskLayer.path toPath:path];
    _maskLayer.path = path;
}

- (void)addAnimationFromPath:(CGPathRef)fromPath toPath:(CGPathRef)toPath {
    if (!fromPath || !toPath || self.animationDisable) return;
    UIBezierPath *originPath = [UIBezierPath bezierPathWithCGPath:fromPath];
    UIBezierPath *targetPath = [UIBezierPath bezierPathWithCGPath:toPath];
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    anim.duration = 0.15;
    anim.fromValue = (__bridge id _Nullable)(originPath.CGPath);
    anim.toValue = (__bridge id _Nullable)(targetPath.CGPath);
    anim.removedOnCompletion = YES;
    [_maskLayer addAnimation:anim forKey:@"PathKey"];
}

@end
