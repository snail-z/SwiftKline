//
//  UIColor+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (PKExtend)

/** 返回相同RGBA值对应的颜色 */
+ (UIColor *)pk_colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a;

/** 返回相同RGB值对应的颜色 */
+ (UIColor *)pk_colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b;

/** 返回十六进制颜色值对应的颜色 (包含alpha) */
+ (UIColor *)pk_colorWithHexRGBA:(NSUInteger)rgbaValue;

/** 返回十六进制颜色值对应的颜色 */
+ (UIColor *)pk_colorWithHexRGB:(NSUInteger)rgbValue;

/** 十六进制颜色值转RGB颜色 */
+ (nullable UIColor *)pk_colorWithHexString:(NSString *)hexString;

/** 返回颜色对应的十六进制颜色值 */
- (NSUInteger)pk_hexRGBAValue;

/** 返回颜色对应的十六进制颜色值 */
- (NSUInteger)pk_hexRGBValue;

/** 返回颜色对应的十六进制颜色值(rgba值数组) */
- (NSArray<NSNumber *> *)pk_RGBAValues;

/** 返回颜色的RGB值对应的十六进制字符串 */
- (nullable NSString *)pk_hexString;

/** 返回颜色的RGBA值对应的十六进制字符串 */
- (nullable NSString *)pk_hexStringWithAlpha;

/** 获取颜色的alpha值 (取值0.0~1.0) */
- (CGFloat)pk_alphaValue;

/** 系统蓝 */
+ (UIColor *)pk_systemBlueColor;

/** 分隔线颜色 */
+ (UIColor *)pk_separatorLineColor;

/** 随机色 */
+ (UIColor *)pk_randomColor;

@end

NS_ASSUME_NONNULL_END
