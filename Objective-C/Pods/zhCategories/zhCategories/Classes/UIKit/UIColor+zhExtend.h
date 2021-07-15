//
//  UIColor+zhExtend.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/3.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (zhExtend)

+ (UIColor *)zh_r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b a:(uint8_t)a;
+ (UIColor *)zh_r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b;
+ (UIColor *)zh_rgba:(NSUInteger)rgba;
+ (UIColor *)zh_randomColor;
- (NSUInteger)zh_rgbaValue;

/** 十六进制颜色字符转RGB颜色 */
+ (nullable UIColor *)zh_colorWithHexString:(NSString*)hexString;

/** 返回颜色的RGB值对应的十六进制字符串 */
- (nullable NSString *)zh_hexString;

/** 返回颜色的RGBA值对应的十六进制字符串 */
- (nullable NSString *)zh_hexStringWithAlpha;

/** 获取颜色的alpha值 (取值0.0~1.0) */
@property (nonatomic, assign, readonly) CGFloat zh_alpha;

@end

NS_ASSUME_NONNULL_END
