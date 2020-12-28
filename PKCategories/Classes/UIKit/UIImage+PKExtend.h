//
//  UIImage+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (PKExtend)

/** 根据颜色创建并返回一个纯色的图像 */
+ (nullable UIImage *)pk_imageWithColor:(UIColor *)color;

/** 根据颜色和大小创建并返回一个纯色的图像 */
+ (nullable UIImage *)pk_imageWithColor:(UIColor *)color size:(CGFloat)size;

/** 根据文字和字体大小生成一个文本图像 */
+ (nullable UIImage *)pk_imageWithString:(NSString *)aString fontSize:(CGFloat)size margin:(CGFloat)margin;

/** 该图像是否有alpha通道 */
- (BOOL)pk_hasAlphaChannel;

/** 获取app启动图 */
+ (nullable UIImage *)pk_getLaunchImage;

/** 返回对layer截图的UIImage */
+ (UIImage *)pk_imageWithCapturedLayer:(CALayer *)layer;

/** 截取图像中的指定区域并返回新图像 */
+ (UIImage *)pk_imageWithCapturedFromImage:(UIImage *)bigImage inRect:(CGRect)imageRect;

/** 压缩图片到指定size */
- (nullable UIImage *)pk_imageWithScaledToTargetSize:(CGSize)targetSize;

/** 压缩图片尺寸到指定宽度targetWidth (高度会根据原始图片比例缩小) */
- (nullable UIImage *)pk_imageWithScaledToTargetWidth:(CGFloat)targetWidth;

/** 压缩图片尺寸到指定高度targetHeight (宽度会根据原始图片比例缩小) */
- (nullable UIImage *)pk_imageWithScaledToTargetHeight:(CGFloat)targetHeight;

/** 压缩图片质量到指定大小targetKb (单位KB) */
- (nullable NSData *)pk_imageWithCompressedQualityToTargetKb:(NSInteger)targetKb;

@end


@interface UIImage (PKRotate)

/**
 *  @brief 修正图片旋转
 *
 *  @return 修正后的图片
 */
- (UIImage *)pk_fixOrientation;

/**
* @brief 返回旋转后的新图片(相对于中心点旋转)
*
* @param radians 逆时针旋转弧度
* @param fitSize YES：图像大小将适应原始内容尺寸
*                 NO：图像的大小不会改变，超出内容部分将忽略
*
* @return 旋转后的新图片或nil
*/
- (nullable UIImage *)pk_imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize;

/** 水平翻转图片 */
- (nullable UIImage *)pk_imageByFlipHorizontal;

/** 竖直翻转图片 */
- (nullable UIImage *)pk_imageByFlipVertical;

/** 将图片按顺时针方向旋转180° ↻ */
- (nullable UIImage *)pk_imageByRotate180;

/** 将图片按逆时针方向旋转90° ⤺ */
- (nullable UIImage *)pk_imageByRotateLeft90;

/** 将图片按顺时针方向旋转90° ⤼ */
- (nullable UIImage *)pk_imageByRotateRight90;

@end


@interface UIImage (PKSaved)

/** 保存图片到手机相册并回调状态 */
- (void)pk_saveToAlbumFinished:(void (^ __nullable)(UIImage *image, NSError *error))block;

@end

NS_ASSUME_NONNULL_END
