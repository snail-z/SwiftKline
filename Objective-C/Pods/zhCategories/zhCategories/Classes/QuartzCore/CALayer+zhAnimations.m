//
//  CALayer+zhAnimations.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/6.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "CALayer+zhAnimations.h"

@implementation CALayer (zhAnimations)

- (CAMediaTimingFunction *)_makeMediaFunction:(UIViewAnimationCurve)curve {
    NSString *mediaFunction;
    switch (curve) {
        case UIViewAnimationCurveEaseInOut: {
            mediaFunction = kCAMediaTimingFunctionEaseInEaseOut;
        } break;
        case UIViewAnimationCurveEaseIn: {
            mediaFunction = kCAMediaTimingFunctionEaseIn;
        } break;
        case UIViewAnimationCurveEaseOut: {
            mediaFunction = kCAMediaTimingFunctionEaseOut;
        } break;
        case UIViewAnimationCurveLinear: {
            mediaFunction = kCAMediaTimingFunctionLinear;
        } break;
        default: {
            mediaFunction = kCAMediaTimingFunctionDefault;
        } break;
    }
    return [CAMediaTimingFunction functionWithName:mediaFunction];
}

- (void)zh_addShakeAnimation {
    [self zh_addShakeAnimationWithDuration:0.06 repeatCount:3 animationCurve:UIViewAnimationCurveLinear];
}

- (void)zh_addShakeAnimationWithDuration:(NSTimeInterval)duration
                             repeatCount:(float)repeatCount
                          animationCurve:(UIViewAnimationCurve)curve {
    if (duration <= 0) return;
    CGPoint position = self.position;
    CGPoint x = CGPointMake(position.x + 5, position.y);
    CGPoint y = CGPointMake(position.x - 5, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[self _makeMediaFunction:curve]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:duration];
    [animation setRepeatCount:repeatCount];
    [self addAnimation:animation forKey:@"_zh_categories.shake"];
}

- (void)zh_removePreviousShakeAnimation {
    [self removeAnimationForKey:@"_zh_categories.shake"];
}

- (void)zh_addBounceAnimation {
    [self zh_addBounceAnimationWithDuration:0.15 repeatCount:3 animationCurve:UIViewAnimationCurveLinear];
}

- (void)zh_addBounceAnimationWithDuration:(NSTimeInterval)duration
                              repeatCount:(float)repeatCount
                           animationCurve:(UIViewAnimationCurve)curve {
    if (duration <= 0) return;
    CGPoint position = self.position;
    CGSize size = self.bounds.size;
    CGFloat verticalOffset = size.height / 4;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[self _makeMediaFunction:curve]];
    [animation setValues:@[
                           [NSValue valueWithCGPoint:CGPointMake(position.x, position.y)],
                           [NSValue valueWithCGPoint:CGPointMake(position.x, position.y-verticalOffset)],
                           [NSValue valueWithCGPoint:CGPointMake(position.x, position.y)],
                           [NSValue valueWithCGPoint:CGPointMake(position.x, position.y+verticalOffset)],
                           [NSValue valueWithCGPoint:CGPointMake(position.x, position.y)]
                           ]];
    [animation setDuration:duration];
    [animation setRepeatCount:repeatCount];
    [animation setFillMode:kCAFillModeForwards];
    [self addAnimation:animation forKey:@"_zh_categories.bounce"];
}

- (void)zh_removePreviousBounceAnimation {
    [self removeAnimationForKey:@"_zh_categories.bounce"];
}

@end
