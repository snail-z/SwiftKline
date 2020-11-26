//
//  PKChartFlashingView.m
//  PKChartKit
//
//  Created by zhanghao on 2017/11/27.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKChartFlashingView.h"

@interface PKChartFlashingView () <CAAnimationDelegate> {
    NSTimer *_delayTimer;
}
@property (nonatomic, strong) CAShapeLayer *dotLayer;
@property (nonatomic, strong) CAShapeLayer *flashingLayer;
@property (nonatomic, strong) CAAnimationGroup *zoomInAnimGroup;
@property (nonatomic, strong) CAAnimationGroup *zoomOutAnimGroup;

@end

static NSString *pkZoomInkey = @"zoomInkey";
static NSString *pkZoomOutkey = @"zoomOutkey";

@implementation PKChartFlashingView

- (instancetype)init {
    if (self = [super init]) {
        _flashingLayer = [CAShapeLayer layer];
        _flashingLayer.lineWidth = 0;
        _flashingLayer.hidden = YES;
        [self.layer addSublayer:_flashingLayer];
        
        _dotLayer = [CAShapeLayer layer];
        _dotLayer.lineWidth = 0;
        _dotLayer.hidden = YES;
        [self.layer addSublayer:_dotLayer];
    }
    return self;
}

- (CAAnimationGroup *)zoomInAnimGroup {
    if (!_zoomInAnimGroup) {
        _zoomInAnimGroup = [self makeZoomInAnimation];
    }
    return _zoomInAnimGroup;
}

- (CAAnimationGroup *)zoomOutAnimGroup {
    if (!_zoomOutAnimGroup) {
        _zoomOutAnimGroup = [self makeZoomOutAnimation];
    }
    return _zoomOutAnimGroup;
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
    [group setValue:pkZoomInkey forKey:pkZoomInkey];
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
    [group setValue:pkZoomOutkey forKey:pkZoomOutkey];
    return group;
}

- (CGFloat)standpointRadius {
    if (_standpointRadius) return _standpointRadius;
    return 2;
}

- (UIColor *)standpointColor {
    if (_standpointColor) return _standpointColor;
    return [UIColor redColor];
}

- (UIColor *)flashingColor {
    if (_flashingColor) return _flashingColor;
    return [self.standpointColor colorWithAlphaComponent:0.5];
}

- (CGFloat)flashingRadius {
    if (_flashingRadius) return _flashingRadius;
    return self.standpointRadius * 3.5;
}

- (void)updateContents {
    CGFloat diameter = self.standpointRadius * 2;
    CGPoint center = self.center;
    self.frame = (CGRect){.size = CGSizeMake(diameter, diameter)};
    self.center = center;
    CGPoint position = CGPointMake(self.standpointRadius, self.standpointRadius);
    
    UIBezierPath *pathA = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:self.standpointRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
    _dotLayer.path = pathA.CGPath;
    _dotLayer.fillColor = self.standpointColor.CGColor;
    _dotLayer.position = position;
    
    UIBezierPath *pathB = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:self.flashingRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
    _flashingLayer.path = pathB.CGPath;
    _flashingLayer.fillColor = self.flashingColor.CGColor;
    _flashingLayer.position = position;
}

- (void)startAnimating {
    if (self.isAnimating) return;
    _isAnimating = YES;
    if (_dotLayer.hidden) {
        _dotLayer.hidden = NO;
        _flashingLayer.hidden = NO;
        [self updateContents];
    }
    [_flashingLayer removeAllAnimations];
    [_flashingLayer addAnimation:self.zoomInAnimGroup forKey:pkZoomInkey];
}

- (void)zoomOutAnimation {
    [_flashingLayer removeAllAnimations];
    [_flashingLayer addAnimation:self.zoomOutAnimGroup forKey:pkZoomOutkey];
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
    
    if ([[anim valueForKey:pkZoomInkey] isEqualToString:pkZoomInkey]) {
        [self zoomOutAnimation];
    } else if ([[anim valueForKey:pkZoomOutkey] isEqualToString:pkZoomOutkey]) {
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
    [_flashingLayer removeAllAnimations];
    [self startAnimating];
}

- (void)freed {
    [_delayTimer invalidate];
    _delayTimer = nil;
    _isAnimating = NO;
    [_flashingLayer removeAllAnimations];
    self.zoomInAnimGroup.delegate = nil;
    self.zoomOutAnimGroup.delegate = nil;
}

@end
