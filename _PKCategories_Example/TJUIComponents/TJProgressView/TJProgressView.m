//
//  TJProgressView.m
//  TJCategories_Example
//
//  Created by zhanghao on 2020/12/21.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import "TJProgressView.h"
#import "TJProgressLayer.h"

@implementation TJProgressBarView

+ (Class)layerClass {
    return [TJProgressBarLayer class];
}

- (TJProgressBarLayer *)baseLayer {
    return (id)self.layer;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
    _trackTintColor = trackTintColor;
    self.baseLayer.trackTintColor = trackTintColor.CGColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;
    self.baseLayer.progressTintColor = progressTintColor.CGColor;
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration {
    _animationDuration = animationDuration;
    self.baseLayer.animationDuration = animationDuration;
}

- (void)setAdjustsRoundedCornersAutomatically:(BOOL)adjustsRoundedCornersAutomatically {
    _adjustsRoundedCornersAutomatically = adjustsRoundedCornersAutomatically;
    self.baseLayer.adjustsRoundedCornersAutomatically = adjustsRoundedCornersAutomatically;
}

- (void)setProgress:(float)progress {
    [self setProgress:progress animated:false];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    _progress = progress;
    [self.baseLayer setProgress:progress animated:animated];
}

@end


@interface TJProgressArcView ()

@property(nonatomic, readonly) TJProgressArcLayer *baseLayer;

@end

@implementation TJProgressArcView

+ (Class)layerClass {
    return [TJProgressArcLayer class];
}

- (TJProgressArcLayer *)baseLayer {
    return (id)self.layer;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
    _trackTintColor = trackTintColor;
    self.baseLayer.trackTintColor = trackTintColor.CGColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;
    self.baseLayer.progressTintColor = progressTintColor.CGColor;
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration {
    _animationDuration = animationDuration;
    self.baseLayer.animationDuration = animationDuration;
}

- (void)setStartAngle:(CGFloat)startAngle {
    _startAngle = startAngle;
    self.baseLayer.startAngle = startAngle;
}

- (void)setEndAngle:(CGFloat)endAngle {
    _endAngle = endAngle;
    self.baseLayer.endAngle = endAngle;
}

- (void)setIsClockwise:(BOOL)isClockwise {
    _isClockwise = isClockwise;
    self.baseLayer.isClockwise = isClockwise;
}

- (void)setTrackWidth:(CGFloat)trackWidth {
    _trackWidth = trackWidth;
    self.baseLayer.trackWidth = trackWidth;
}

- (void)setProgress:(float)progress {
    [self setProgress:progress animated:false];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    _progress = progress;
    [self.baseLayer setProgress:progress animated:animated];
}

@end


CGFloat const kArcStartAngleTop = M_PI*3/2;
CGFloat const kArcStartAngleRight = 0;
CGFloat const kArcStartAngleBottom = M_PI_2;
CGFloat const kArcStartAngleLeft = M_PI;
