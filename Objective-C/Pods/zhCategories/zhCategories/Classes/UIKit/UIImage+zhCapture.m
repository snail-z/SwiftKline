//
//  UIImage+zhCapture.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/2.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIImage+zhCapture.h"

@implementation UIImage (zhCapture)

+ (UIImage *)zh_captureImageWithLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, [UIScreen mainScreen].scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

+ (UIImage *)zh_captureImageFromImage:(UIImage *)bigImage designatedRect:(CGRect)imageRect {
    CGImageRef imageRef = bigImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, imageRect);
    CGSize size = CGSizeMake(CGRectGetWidth(imageRect), CGRectGetHeight(imageRect));
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, imageRect, subImageRef);
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return smallImage;
}

@end
