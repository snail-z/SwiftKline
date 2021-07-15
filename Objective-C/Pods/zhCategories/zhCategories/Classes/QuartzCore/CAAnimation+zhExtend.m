
//
//  CAAnimation+zhExtend.m
//  zhCategories_Example
//
//  Created by zhanghao on 2017/12/24.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "CAAnimation+zhExtend.h"

@implementation CAAnimation (zhExtend)

+ (CABasicAnimation *)zh_zoomAnimation {
    return [CAAnimation zh_animationWithKeyPath:@"transform.scale" duration:1.25 repeatCount:MAXFLOAT fromValue:1.5 toValue:0.5];
}

+ (CABasicAnimation *)zh_fadeAnimation {
    return [CAAnimation zh_animationWithKeyPath:@"opacity" duration:1.25 repeatCount:MAXFLOAT fromValue:0.5 toValue:1.0];
}

+ (CABasicAnimation *)zh_animationWithKeyPath:(nullable NSString *)path
                                     duration:(double)duration
                                  repeatCount:(float)repeatCount
                                    fromValue:(double)fromValue
                                      toValue:(double)toValue {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:path];
    animation.fromValue = @(fromValue);
    animation.toValue = @(toValue);
    animation.repeatCount = repeatCount;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.autoreverses = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return  animation;
}

@end
