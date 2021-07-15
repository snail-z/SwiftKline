//
//  UIImage+zhCapture.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/2.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (zhCapture)

/** 返回对layer截图的UIImage */
+ (UIImage *)zh_captureImageWithLayer:(CALayer *)layer;

/** 截取图像中的指定区域并返回新图像 */
+ (UIImage *)zh_captureImageFromImage:(UIImage *)bigImage designatedRect:(CGRect)imageRect;

@end
