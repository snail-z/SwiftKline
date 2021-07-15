//
//  CAAnimation+zhExtend.h
//  zhCategories_Example
//
//  Created by zhanghao on 2017/12/24.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAAnimation (zhExtend)

+ (CABasicAnimation *)zh_zoomAnimation;
+ (CABasicAnimation *)zh_fadeAnimation;

+ (CABasicAnimation *)zh_animationWithKeyPath:(nullable NSString *)path
                                     duration:(double)duration
                                  repeatCount:(float)repeatCount
                                    fromValue:(double)fromValue
                                      toValue:(double)toValue;

@end

NS_ASSUME_NONNULL_END
