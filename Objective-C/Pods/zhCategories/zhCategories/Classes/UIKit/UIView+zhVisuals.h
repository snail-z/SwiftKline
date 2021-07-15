//
//  UIView+zhVisuals.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/3.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, zhSidelinePosition) {
    zhSidelinePositionLeft          = 1 << 0,
    zhSidelinePositionRight         = 1 << 1,
    zhSidelinePositionTop           = 1 << 2,
    zhSidelinePositionBottom        = 1 << 3,
    zhSidelinePositionAllSidelines  = ~0UL
};

@interface UIView (zhVisuals)

/** 为视图添加阴影效果 */
- (void)zh_addLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

/** 为视图指定部分添加圆角 (需要设置该视图frame，才会生效) */
- (void)zh_addCornerRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners;

/** 为视图指定位置添加边框线 */
- (void)zh_addSidelinePosition:(zhSidelinePosition)position
                     lineWidth:(CGFloat)width lineColor:(UIColor *)color;

/** 为视图指定位置添加1px边框线，默认颜色[UIColor grayColor] */
- (void)zh_add1pxSidelinePosition:(zhSidelinePosition)position;

@end
