//
//  UIImage+zhCompression.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/6.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (zhCompression)

/** 压缩图片到指定size */
- (nullable UIImage *)zh_imageWithScaledToTargetSize:(CGSize)size;

/** 压缩图片尺寸到指定宽度targetWidth (高度会根据原始图片比例缩小) */
- (nullable UIImage *)zh_imageWithScaledToTargetWidth:(CGFloat)targetWidth;

/** 压缩图片尺寸到指定高度targetHeight (宽度会根据原始图片比例缩小) */
- (nullable UIImage *)zh_imageWithScaledToTargetHeight:(CGFloat)targetHeight;

/** 压缩图片质量到指定大小targetKb (单位KB) */
- (nullable NSData *)zh_imageWithCompressQualityToTargetKb:(NSInteger)targetKb;

@end
