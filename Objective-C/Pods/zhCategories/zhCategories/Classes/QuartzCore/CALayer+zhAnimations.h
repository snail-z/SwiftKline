//
//  CALayer+zhAnimations.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/6.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (zhAnimations)

- (void)zh_addShakeAnimation;
- (void)zh_addShakeAnimationWithDuration:(NSTimeInterval)duration
                             repeatCount:(float)repeatCount
                          animationCurve:(UIViewAnimationCurve)curve;
- (void)zh_removePreviousShakeAnimation;

- (void)zh_addBounceAnimation;
- (void)zh_addBounceAnimationWithDuration:(NSTimeInterval)duration
                              repeatCount:(float)repeatCount
                           animationCurve:(UIViewAnimationCurve)curve;
- (void)zh_removePreviousBounceAnimation;

@end
