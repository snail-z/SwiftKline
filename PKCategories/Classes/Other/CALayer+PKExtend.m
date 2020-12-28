//
//  CALayer+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2018/10/30.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "CALayer+PKExtend.h"

@implementation CALayer (PKFrameAdjust)

- (CGFloat)pk_left {
    return self.frame.origin.x;
}

- (void)setPk_left:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)pk_top {
    return self.frame.origin.y;
}

- (void)setPk_top:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)pk_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setPk_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)pk_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setPk_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)pk_width {
    return self.frame.size.width;
}

- (void)setPk_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)pk_height {
    return self.frame.size.height;
}

- (void)setPk_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)pk_center {
    return CGPointMake(self.frame.origin.x + self.frame.size.width * 0.5,
                       self.frame.origin.y + self.frame.size.height * 0.5);
}

- (void)setPk_center:(CGPoint)center {
    CGRect frame = self.frame;
    frame.origin.x = center.x - frame.size.width * 0.5;
    frame.origin.y = center.y - frame.size.height * 0.5;
    self.frame = frame;
}

- (CGFloat)pk_centerX {
    return self.frame.origin.x + self.frame.size.width * 0.5;
}

- (void)setPk_centerX:(CGFloat)centerX {
    CGRect frame = self.frame;
    frame.origin.x = centerX - frame.size.width * 0.5;
    self.frame = frame;
}

- (CGFloat)pk_centerY {
    return self.frame.origin.y + self.frame.size.height * 0.5;
}

- (void)setPk_centerY:(CGFloat)centerY {
    CGRect frame = self.frame;
    frame.origin.y = centerY - frame.size.height * 0.5;
    self.frame = frame;
}

- (CGPoint)pk_origin {
    return self.frame.origin;
}

- (void)setPk_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)pk_size {
    return self.frame.size;
}

- (void)setPk_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end


@implementation CALayer (PKExtend)

- (UIColor *)pk_borderColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

- (void)setPk_borderColor:(UIColor *)pk_borderColor {
    if (!pk_borderColor) return;
    self.borderColor = pk_borderColor.CGColor;
    self.borderWidth = 1 / [UIScreen mainScreen].scale;
}

- (void)pk_removeAllSublayers {
    while (self.sublayers.count) {
        [self.sublayers.lastObject removeFromSuperlayer];
    }
}

- (void)pk_addShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.shadowColor = color.CGColor;
    self.shadowOffset = offset;
    self.shadowRadius = radius;
    self.shadowOpacity = 1;
    self.shouldRasterize = YES;
    self.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)pk_addShadow:(UIColor *)color opacity:(CGFloat)opacity radius:(CGFloat)radius {
    self.shadowColor = color.CGColor;
    self.shadowOffset = CGSizeMake(0, 0);
    self.shadowRadius = radius;
    self.shadowOpacity = opacity;
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat x = self.bounds.origin.x;
    CGFloat y = self.bounds.origin.y;
    CGFloat offset = 0.f;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint topLeft = self.bounds.origin;
    CGPoint topRight = CGPointMake(x + width, y);
    CGPoint bottomRight = CGPointMake(x + width, y + height);
    CGPoint bottomLeft = CGPointMake(x, y + height);
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y - offset)];
    [path addLineToPoint:CGPointMake(topRight.x + offset, topRight.y - offset)];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y + offset)];
    [path addLineToPoint:CGPointMake(bottomLeft.x - offset, bottomLeft.y + offset)];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y - offset)];
    self.shadowPath = path.CGPath;
}

@end


@implementation CALayer (PKAnimation)

- (CAMediaTimingFunction *)_pk_makeMediaTimingFunction:(UIViewAnimationCurve)animationCurve {
    switch (animationCurve) {
        case UIViewAnimationCurveEaseInOut:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        case UIViewAnimationCurveEaseIn:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        case UIViewAnimationCurveEaseOut:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        case UIViewAnimationCurveLinear:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        default:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];;
    }
}

- (void)pk_addShakeAnimationWithDuration:(NSTimeInterval)duration
                             repeatCount:(float)repeatCount
                              horizontal:(BOOL)horizontal
                                  offset:(CGFloat)offset {
    if (duration <= 0) return;
    CGPoint position = self.position;
    CGFloat horizontalOffset = horizontal ? offset : 0;
    CGFloat verticalOffset = horizontal ? 0 : offset;
    NSArray *values = @[
                        [NSValue valueWithCGPoint:CGPointMake(position.x, position.y)],
                        [NSValue valueWithCGPoint:CGPointMake(position.x - horizontalOffset, position.y - verticalOffset)],
                        [NSValue valueWithCGPoint:CGPointMake(position.x, position.y)],
                        [NSValue valueWithCGPoint:CGPointMake(position.x + horizontalOffset, position.y + verticalOffset)],
                        [NSValue valueWithCGPoint:CGPointMake(position.x, position.y)]
                        ];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.values = values;
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    [self addAnimation:animation forKey:@"_PKCategories.anim.positionKey"];
}

- (void)pk_removePreviousShakeAnimation {
    [self removeAnimationForKey:@"_PKCategories.anim.positionKey"];
}

- (void)pk_addHorizontalShakeAnimation {
    return [self pk_addShakeAnimationWithDuration:0.2
                                      repeatCount:3
                                       horizontal:YES
                                           offset:12];
}

- (void)pk_addVerticalShakeAnimation {
    return [self pk_addShakeAnimationWithDuration:0.2
                                      repeatCount:3
                                       horizontal:NO
                                           offset:12];
}

- (void)pk_addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve {
    if (duration <= 0) return;
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [self _pk_makeMediaTimingFunction:curve];
    transition.type = kCATransitionFade;
    [self addAnimation:transition forKey:@"_PKCategories.anim.kCATransitionFade"];
}

- (void)pk_removePreviousFadeAnimation {
    [self removeAnimationForKey:@"_PKCategories.anim.kCATransitionFade"];
}

@end
