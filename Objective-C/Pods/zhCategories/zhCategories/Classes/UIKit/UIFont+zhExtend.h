//
//  UIFont+zhExtend.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/13.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (zhExtend)

/** 将像素值px转成point(磅) */
+ (CGFloat)zh_pointsByPixel:(CGFloat)px;
+ (UIFont *)zh_fontByPixel:(CGFloat)px;
+ (UIFont *)zh_boldFontByPixel:(CGFloat)px;
+ (UIFont *)zh_fontWithName:(NSString *)fontName pixel:(CGFloat)px;
+ (NSArray<NSString *> *)zh_familyNames;

@end
