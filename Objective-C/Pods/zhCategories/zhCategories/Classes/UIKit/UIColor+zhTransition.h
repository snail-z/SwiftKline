//
//  UIColor+zhTransition.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/3.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (zhTransition)

/** 将两种颜色过渡 */
+ (UIColor *)zh_transitionColor:(UIColor *)color1 toColor:(UIColor *)color2 width:(CGFloat)width;
+ (UIColor *)zh_transitionColor:(UIColor *)color1 toColor:(UIColor *)color2 height:(CGFloat)height;
+ (UIColor *)zh_transitionColor:(UIColor *)color1 toColor:(UIColor *)color2 size:(CGSize)size;

@end
