//
//  CALayer+zhExtend.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/6.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "CALayer+zhExtend.h"

@implementation CALayer (zhExtend)

- (void)zh_removeAllSublayers {
    while (self.sublayers.count) {
        [self.sublayers.lastObject removeFromSuperlayer];
    }
}

- (void)zh_setLayerShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.shadowColor = color.CGColor;
    self.shadowOffset = offset;
    self.shadowRadius = radius;
    self.shadowOpacity = 1;
    self.shouldRasterize = YES;
    self.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
