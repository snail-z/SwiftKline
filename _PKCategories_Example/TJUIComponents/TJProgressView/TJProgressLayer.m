//
//  TJProgressLayer.m
//  TJCategories_Example
//
//  Created by zhanghao on 2020/12/16.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import "TJProgressLayer.h"

@interface TJProgressBarLayer ()

@property (nonatomic, strong) CALayer *activeLayer;

@end

@implementation TJProgressBarLayer

- (instancetype)init {
    if (self = [super init]) {
        self.masksToBounds = YES;
        _animationDuration = 0.25;
        [self sublayerInitialization];
    }
    return self;
}

- (void)sublayerInitialization {
    _activeLayer = [CALayer layer];
    _activeLayer.anchorPoint = CGPointZero;
    [self addSublayer:_activeLayer];
}

- (void)setAdjustsRoundedCornersAutomatically:(BOOL)adjustsRoundedCornersAutomatically {
    _adjustsRoundedCornersAutomatically = adjustsRoundedCornersAutomatically;
    [self setNeedsLayout];
}

- (void)layoutSublayers {
    [super layoutSublayers];
    if (_adjustsRoundedCornersAutomatically) {
        self.cornerRadius = self.bounds.size.height / 2;
    }
}

- (void)setTrackTintColor:(CGColorRef)trackTintColor {
    _trackTintColor = trackTintColor;
    self.backgroundColor = trackTintColor;
}

- (void)setProgressTintColor:(CGColorRef)progressTintColor {
    _progressTintColor = progressTintColor;
    _activeLayer.backgroundColor = progressTintColor;
}

- (void)setProgress:(float)progress {
    [self setProgress:progress animated:false];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    _progress = progress;
    
    CGFloat moveWidth = MIN(MAX(0, progress), 1) * self.bounds.size.width;
    CGRect toRect = CGRectMake(0, 0, moveWidth, self.bounds.size.height);
    _activeLayer.frame = toRect;
    
    if (!animated) return;
    
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"bounds"];
    CGRect fromRect = CGRectMake(0, 0, 0, self.bounds.size.height);
    basic.fromValue = [NSValue valueWithCGRect:fromRect];
    basic.toValue = [NSValue valueWithCGRect:toRect];
    basic.duration = self.animationDuration;
    basic.fillMode = kCAFillModeForwards;
    basic.removedOnCompletion = false;
    [_activeLayer addAnimation:basic forKey:nil];
}

@end


@interface TJProgressArcLayer ()

@property (nonatomic, strong) CALayer *containerLayer;
@property (nonatomic, strong) CAShapeLayer *inactiveLayer;
@property (nonatomic, strong) CAShapeLayer *activeLayer;

@end

@implementation TJProgressArcLayer

- (instancetype)init {
    if (self = [super init]) {
        self.masksToBounds = YES;
        [self defaultInitialization];
        [self sublayerInitialization];
    }
    return self;
}

- (void)defaultInitialization {
    _animationDuration = 0.25;
    _startAngle = 0;
    _endAngle = -1;
    _isClockwise = YES;
    _trackWidth = 10;
}

- (void)sublayerInitialization {
    _containerLayer = [CALayer layer];
    [self addSublayer:_containerLayer];
    
    _activeLayer = [CAShapeLayer layer];
    [self addSublayer:_activeLayer];
    
    _inactiveLayer = [CAShapeLayer layer];
    [self insertSublayer:_inactiveLayer atIndex:0];
}

- (void)layoutSublayers {
    [super layoutSublayers];
    _containerLayer.frame = self.bounds;
}

- (CGFloat)getCloseAngle {
    return self.startAngle - (self.isClockwise ? -M_PI : M_PI) * 2;
}

- (void)setProgress:(float)progress {
    [self setProgress:progress animated:false];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    _progress = progress;
    
    CGFloat closeAngle = self.endAngle;
    if (self.endAngle < 0) {
        closeAngle = [self getCloseAngle];
    }
    
    CGFloat maxWidth = MAX(self.bounds.size.width, self.bounds.size.height);
    CGPoint center = CGPointMake(maxWidth / 2, maxWidth / 2);
    CGFloat radius = (maxWidth - self.trackWidth) / 2;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:radius startAngle:self.startAngle endAngle:closeAngle clockwise:self.isClockwise];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    _inactiveLayer.fillColor = UIColor.clearColor.CGColor;
    _inactiveLayer.strokeColor = self.trackTintColor;
    _inactiveLayer.lineWidth = self.trackWidth;
    _inactiveLayer.path = path.CGPath;
    
    _activeLayer.fillColor = UIColor.clearColor.CGColor;
    _activeLayer.strokeColor = UIColor.whiteColor.CGColor;
    _activeLayer.lineWidth = self.trackWidth;
    _activeLayer.path = path.CGPath;
    
    _containerLayer.backgroundColor = self.progressTintColor;
    _containerLayer.mask = _activeLayer;

    float endValue = MIN(MAX(0, progress), 1);

    _activeLayer.strokeStart = 0;
    _activeLayer.strokeEnd = endValue;

    [CATransaction commit];
    
    if (!animated) return;

    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basic.fromValue = @(0);
    basic.toValue = @(endValue);
    basic.duration = self.animationDuration;
    basic.fillMode = kCAFillModeForwards;
    basic.removedOnCompletion = false;
    [_activeLayer addAnimation:basic forKey:nil];
}

@end
