//
//  UIImage+zhCompression.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/6.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIImage+zhCompression.h"

@implementation UIImage (zhCompression)

- (UIImage *)zh_imageWithScaledToTargetSize:(CGSize)size {
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)zh_imageWithScaledToTargetWidth:(CGFloat)targetWidth {
    if (targetWidth <= 0) return nil;
    CGSize originSize = self.size;
    if (originSize.width > targetWidth) {
        CGFloat scaleFactor = originSize.height / originSize.width;
        CGFloat targetHeight = targetWidth * scaleFactor;
        CGSize targetSize = CGSizeMake(targetWidth, targetHeight);
        return [self zh_imageWithScaledToTargetSize:targetSize];
    }
    return self;
}

- (UIImage *)zh_imageWithScaledToTargetHeight:(CGFloat)targetHeight {
    if (targetHeight <= 0) return nil;
    CGSize originSize = self.size;
    if (originSize.height > targetHeight) {
        CGFloat scaleFactor = originSize.width / originSize.height;
        CGFloat targetWidth = targetHeight * scaleFactor;
        CGSize targetSize = CGSizeMake(targetWidth, targetHeight);
        return [self zh_imageWithScaledToTargetSize:targetSize];
    }
    return self;
}

- (NSData *)zh_imageWithCompressQualityToTargetKb:(NSInteger)targetKb {
    if (targetKb <= 0) return nil;
    CGFloat compression = 1.0f;
    CGFloat minCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(self, compression);
    NSUInteger imageKb = [imageData length] / 1024;
    while (imageKb > targetKb && compression > minCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(self, compression);
        imageKb = [imageData length] / 1024;
    }
    return imageData;
}

@end
