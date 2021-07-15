//
//  TQChartPulsingView.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/25.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQChartPulsingView.h"

@interface TQChartPulsingView () <CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *dotLayer;
@property (nonatomic, strong) CAShapeLayer *pulsingLayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isZoomInAnimating;
//zoomFlag;
@end

@implementation TQChartPulsingView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self sublayerInitialization];
    }
    return self;
}

- (CGFloat)standpointRadius {
    if (!_standpointRadius) {
        return 2;
    }
    return _standpointRadius;
}

- (UIColor *)standpointColor {
    if (!_standpointColor) {
        return [UIColor redColor];
    }
    return _standpointColor;
}

- (UIColor *)pulsingColor {
    if (!_pulsingColor) {
        return [self.standpointColor colorWithAlphaComponent:0.5];
    }
    return _pulsingColor;
}

- (CGFloat)pulsingRadius {
    if (!_pulsingRadius) {
        return self.standpointRadius * 3.5;
    }
    return _pulsingRadius;
}

- (void)sublayerInitialization {
    _pulsingLayer = [CAShapeLayer layer];
    _pulsingLayer.lineWidth = 0;
    _pulsingLayer.hidden = YES;
    [self.layer addSublayer:_pulsingLayer];
    
    _dotLayer = [CAShapeLayer layer];
    _dotLayer.lineWidth = 0;
    _dotLayer.hidden = YES;
    [self.layer addSublayer:_dotLayer];
}

- (void)updateContents {
    [self layoutIfNeeded];
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:self.standpointRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
    _dotLayer.path = path.CGPath;
    _dotLayer.fillColor = self.standpointColor.CGColor;
    _dotLayer.position = center;
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:self.pulsingRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
    _pulsingLayer.path = path2.CGPath;
    _pulsingLayer.fillColor = self.pulsingColor.CGColor;
    _pulsingLayer.position = center;
}

- (void)startAnimating {
    if (_isAnimating) return;
    _isAnimating = YES;
    if (_dotLayer.hidden) {
        _dotLayer.hidden = NO;
        [self updateContents];
    }
    
    if (_isZoomInAnimating) return;
    _isZoomInAnimating = YES;
    _pulsingLayer.hidden = NO;
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.delegate = self;
    scaleAnim.fromValue = @(0);
    scaleAnim.toValue = @1;
    
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @(0.5);
    opacityAnim.toValue = @0.9;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = 0.25;
    group.repeatCount = 1;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.animations = @[scaleAnim, opacityAnim];
    [_pulsingLayer addAnimation:group forKey:@"_zoomInKey"];
}

- (void)zoomOutAnimation {
    if (!_isZoomInAnimating) return;
    _isZoomInAnimating = NO;
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @(0.9);
    opacityAnim.toValue = @0;
    
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.fromValue = @(1);
    scaleAnim.toValue = @0.9;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = 0.5;
    group.repeatCount = 1;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    group.animations = @[opacityAnim, scaleAnim];
    [_pulsingLayer addAnimation:group forKey:@"_zoomOutKey"];
}

- (void)stopAnimating {
    if (!_isAnimating) return;
    _isAnimating = NO;
    _isZoomInAnimating = NO;
    _pulsingLayer.hidden = YES;
    [_pulsingLayer removeAllAnimations];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    NSLog(@"a~~~newSuperview is: %@", newSuperview);
    [self freeTimer];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"animationDidStop");
    if (_isZoomInAnimating) {
        [self zoomOutAnimation];
    } else {
        [self freeTimer];
        [self restartDelayed:1.25];
    }
}

- (void)restartDelayed:(NSTimeInterval)delay {
    _timer = [NSTimer timerWithTimeInterval:delay target:self selector:@selector(restartTimerFired) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)restartTimerFired {
    [self startAnimating];
}

- (void)freeTimer {
    [self stopAnimating];
    [_timer invalidate];
    _timer = nil;
}

- (void)dealloc {
    NSLog(@"tipulising 来这里了~~");
    [self freeTimer];
}

@end
