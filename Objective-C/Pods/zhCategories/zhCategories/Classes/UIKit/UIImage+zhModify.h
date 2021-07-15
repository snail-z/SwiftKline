//
//  UIImage+zhModify.h
//  zhCategories_Example
//
//  Created by zhanghao on 2017/12/26.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (zhModify)

/** 返回旋转后的新图片 (相对于中心点旋转) */
- (nullable UIImage *)zh_imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize;

/** 水平翻转图片 */
- (nullable UIImage *)zh_imageByFlipHorizontal;

/**  竖直翻转图片 */
- (nullable UIImage *)zh_imageByFlipVertical;

/** 将图片旋转180° */
- (nullable UIImage *)zh_imageByRotate180;

/** 将图片按逆时针方向旋转90° ⤺ */
- (nullable UIImage *)zh_imageByRotateLeft90;

/** 将图片按顺时针方向旋转90° ⤼ */
- (nullable UIImage *)zh_imageByRotateRight90;

/**
 根据给定的角度来剪切并返回新图像
 @param radius 角度
 @param corners 可设置某一个角
 @param borderWidth 边框宽度
 @param borderColor  边框颜色
 @param borderLineJoin 边界连接类型
 */
- (nullable UIImage *)zh_imageByRoundCornerRadius:(CGFloat)radius
                                 corners:(UIRectCorner)corners
                             borderWidth:(CGFloat)borderWidth
                             borderColor:(nullable UIColor *)borderColor
                          borderLineJoin:(CGLineJoin)borderLineJoin;

- (nullable UIImage *)zh_imageByRoundCornerRadius:(CGFloat)radius
                             borderWidth:(CGFloat)borderWidth
                             borderColor:(nullable UIColor *)borderColor;

- (nullable UIImage *)zh_imageByRoundCornerRadius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
