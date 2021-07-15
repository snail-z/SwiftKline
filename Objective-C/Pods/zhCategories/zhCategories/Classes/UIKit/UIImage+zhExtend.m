//
//  UIImage+zhExtend.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/6.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIImage+zhExtend.h"

@implementation UIImage (zhExtend)

+ (UIImage *)zh_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)zh_imageWithColor:(UIColor *)color {
    return [self zh_imageWithColor:color size:CGSizeMake(1.f, 1.f)];
}

- (CGFloat)zh_scaledHeightByWidth:(CGFloat)byWidth {
    CGFloat scaleFactor = self.size.height / self.size.width;
    return scaleFactor * byWidth;
}

- (CGFloat)zh_scaledWidthByHeight:(CGFloat)byHeight {
    CGFloat scaleFactor = self.size.width / self.size.height;
    return scaleFactor * byHeight;
}

- (BOOL)zh_hasAlphaChannel {
    if (self.CGImage == NULL) return NO;
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage) & kCGBitmapAlphaInfoMask;
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

+ (UIImage *)zh_getLaunchImage {
    NSString *viewOrientation = @"Portrait";
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        viewOrientation = @"Landscape"; // 横屏
    }
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
    NSString *launchImageName = nil;
    for (NSDictionary *dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, currentWindow.bounds.size) &&
            [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    if (!launchImageName) return nil;
    return [UIImage imageNamed:launchImageName];
}

@end
