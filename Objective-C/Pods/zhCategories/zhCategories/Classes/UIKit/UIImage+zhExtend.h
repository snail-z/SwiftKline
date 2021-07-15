//
//  UIImage+zhExtend.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/6.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (zhExtend)

/** 根据颜色创建并返回纯色的图像 */
+ (nullable UIImage *)zh_imageWithColor:(UIColor *)color;

/** 根据颜色和大小创建并返回纯色的图像 */
+ (nullable UIImage *)zh_imageWithColor:(UIColor *)color size:(CGSize)size;

/** 根据宽度获取等比例的高度 (该比例为image自身的宽高比) */
- (CGFloat)zh_scaledHeightByWidth:(CGFloat)byWidth;

/** 根据高度获取等比例的宽度 (该比例为image自身的宽高比) */
- (CGFloat)zh_scaledWidthByHeight:(CGFloat)byHeight;

/** 该图像是否有alpha通道 */
- (BOOL)zh_hasAlphaChannel;

/** 获取app启动图 */
+ (nullable UIImage *)zh_getLaunchImage;

@end

NS_ASSUME_NONNULL_END
