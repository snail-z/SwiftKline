//
//  TQTimePulsingView.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/28.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQTimePulsingView.h"

@interface TQTimePulsingView () <CAAnimationDelegate> {
    CAAnimationGroup *_zoomInGroup;
    CAAnimationGroup *_zoomOutGroup;
}
@property (nonatomic, strong) CAShapeLayer *dotLayer;
@property (nonatomic, strong) CAShapeLayer *pulsingLayer;
@property (nonatomic, strong) NSTimer *delayTimer;

@end

static NSString *tq_zoomInkey = @"zoomInkey";
static NSString *tq_zoomOutkey = @"zoomOutkey";

@implementation TQTimePulsingView


- (instancetype)init {
    if (self = [super init]) {
        [self sublayerInitialization];
    }
    return self;
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
    
    _zoomInGroup = [self makeZoomInAnimation];
    _zoomOutGroup = [self makeZoomOutAnimation];
}

- (CAAnimationGroup *)makeZoomInAnimation {
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.fromValue = @(0);
    scaleAnim.toValue = @1;
    
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @(0.5);
    opacityAnim.toValue = @0.9;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = 0.3;
    group.repeatCount = 1;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.animations = @[scaleAnim, opacityAnim];
    [group setValue:tq_zoomInkey forKey:tq_zoomInkey];
    return group;
}

- (CAAnimationGroup *)makeZoomOutAnimation {
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
    [group setValue:tq_zoomOutkey forKey:tq_zoomOutkey];
    return group;
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

- (void)updateContents {
    CGFloat diameter = self.standpointRadius * 2;
    CGPoint center = self.center;
    self.frame = (CGRect){.size = CGSizeMake(diameter, diameter)};
    self.center = center;
    CGPoint position = CGPointMake(self.standpointRadius, self.standpointRadius);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:self.standpointRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
    _dotLayer.path = path.CGPath;
    _dotLayer.fillColor = self.standpointColor.CGColor;
    _dotLayer.position = position;
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:self.pulsingRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
    _pulsingLayer.path = path2.CGPath;
    _pulsingLayer.fillColor = self.pulsingColor.CGColor;
    _pulsingLayer.position = position;
}

- (void)startAnimating {
    if (self.isAnimating) return;
    _isAnimating = YES;
    if (_dotLayer.hidden) {
        _dotLayer.hidden = NO;
        _pulsingLayer.hidden = NO;
        [self updateContents];
    }
    [_pulsingLayer removeAllAnimations];
    [_pulsingLayer addAnimation:_zoomInGroup forKey:tq_zoomInkey];
}

- (void)zoomOutAnimation {
    [_pulsingLayer removeAllAnimations];
    [_pulsingLayer addAnimation:_zoomOutGroup forKey:tq_zoomOutkey];
}

- (void)stopAnimating {
    if (!self.isAnimating) return;
    _isAnimating = NO;
    [self freed];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self freed];
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (![anim isKindOfClass:[CAAnimationGroup class]]) return;
    
    if ([[anim valueForKey:tq_zoomInkey] isEqualToString:tq_zoomInkey]) {
        [self zoomOutAnimation];
    } else if ([[anim valueForKey:tq_zoomOutkey] isEqualToString:tq_zoomOutkey]) {
        [self delayTimerFired];
    }
}

- (void)delayTimerFired {
    [_delayTimer invalidate];
    _delayTimer = [NSTimer timerWithTimeInterval:1.25 target:self selector:@selector(delayHandler) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_delayTimer forMode:NSRunLoopCommonModes];
}

- (void)delayHandler {
    _isAnimating = NO;
    [_pulsingLayer removeAllAnimations];
    [self startAnimating];
}

- (void)freed {
    [_delayTimer invalidate];
    _delayTimer = nil;
    _isAnimating = NO;
    [_pulsingLayer removeAllAnimations];
    _zoomInGroup.delegate = nil;
    _zoomOutGroup.delegate = nil;
}

@end
