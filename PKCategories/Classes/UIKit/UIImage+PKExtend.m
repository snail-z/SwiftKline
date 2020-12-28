//
//  UIImage+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UIImage+PKExtend.h"
#import <Accelerate/Accelerate.h>
#import <objc/runtime.h>

@implementation UIImage (PKExtend)

+ (UIImage *)pk_imageWithColor:(UIColor *)color {
    return [self pk_imageWithColor:color size:1];
}

+ (UIImage *)pk_imageWithColor:(UIColor *)color size:(CGFloat)size {
    if (!color || size <= 0) return nil;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size, size));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)pk_imageWithString:(NSString *)aString fontSize:(CGFloat)size margin:(CGFloat)margin {
    if (!aString || size <= 0) return nil;
    
    size *= [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContext(CGSizeMake(size, size));
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *backgroudColor = [self getRandomColor:aString];
    CGContextSetStrokeColorWithColor(context, backgroudColor.CGColor);
    CGContextSetFillColorWithColor(context, backgroudColor.CGColor);
    CGContextAddRect(context, CGRectMake(0, 0, size, size));
    CGContextDrawPath(context, kCGPathFillStroke);
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:(size - 2 * margin)],
                                 NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSBackgroundColorAttributeName : [UIColor clearColor]};
    CGSize textSize = [aString sizeWithAttributes:attributes];
    [aString drawInRect:CGRectMake((size - textSize.width) / 2, (size - textSize.height) / 2, textSize.width,
                                textSize.height)
      withAttributes:attributes];
    
    UIImage *originImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return originImage;
}

+ (UIColor *)getRandomColor:(NSString *)randomKey {
    int colorIndex = 0;
    NSArray *colorList = @[ @(0x3A91F3), @(0x74CFDE), @(0xF14E7D), @(0x5585A5), @(0xF9CB4F), @(0xF56B2F) ];
    if (randomKey.length > 0) {
        colorIndex = [randomKey characterAtIndex:randomKey.length - 1] % colorList.count;
    }
    
    long rgbValue = [colorList[colorIndex] longValue];
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(rgbValue & 0xFF)) / 255.0
                           alpha:1];
}

- (BOOL)pk_hasAlphaChannel {
    if (self.CGImage == NULL) return NO;
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage) & kCGBitmapAlphaInfoMask;
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

+ (UIImage *)pk_getLaunchImage {
    NSString *viewOrientation = @"Portrait";
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        viewOrientation = @"Landscape";
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

+ (UIImage *)pk_imageWithCapturedLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, [UIScreen mainScreen].scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

+ (UIImage *)pk_imageWithCapturedFromImage:(UIImage *)bigImage inRect:(CGRect)imageRect {
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

- (UIImage *)pk_imageWithScaledToTargetSize:(CGSize)targetSize {
    if (targetSize.width <= 0 || targetSize.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)pk_imageWithScaledToTargetWidth:(CGFloat)targetWidth {
    if (targetWidth <= 0) return nil;
    if (self.size.width > targetWidth) {
        CGFloat scaleFactor = self.size.height / self.size.width;
        CGFloat targetHeight = targetWidth * scaleFactor;
        CGSize targetSize = CGSizeMake(targetWidth, targetHeight);
        return [self pk_imageWithScaledToTargetSize:targetSize];
    }
    return self;
}

- (UIImage *)pk_imageWithScaledToTargetHeight:(CGFloat)targetHeight {
    if (targetHeight <= 0) return nil;
    if (self.size.height > targetHeight) {
        CGFloat scaleFactor = self.size.width / self.size.height;
        CGFloat targetWidth = targetHeight * scaleFactor;
        CGSize targetSize = CGSizeMake(targetWidth, targetHeight);
        return [self pk_imageWithScaledToTargetSize:targetSize];
    }
    return self;
}

- (NSData *)pk_imageWithCompressedQualityToTargetKb:(NSInteger)targetKb {
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


@implementation UIImage (PKRotate)

- (UIImage *)pk_fixOrientation {
    UIImage *aImage = self;
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)pk_imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize {
    size_t width = (size_t)CGImageGetWidth(self.CGImage);
    size_t height = (size_t)CGImageGetHeight(self.CGImage);
    CGRect newRect = CGRectApplyAffineTransform(CGRectMake(0., 0., width, height),
                                                fitSize ? CGAffineTransformMakeRotation(radians) : CGAffineTransformIdentity);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 (size_t)newRect.size.width,
                                                 (size_t)newRect.size.height,
                                                 8,
                                                 (size_t)newRect.size.width * 4,
                                                 colorSpace,
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGContextSetShouldAntialias(context, true);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextTranslateCTM(context, +(newRect.size.width * 0.5), +(newRect.size.height * 0.5));
    CGContextRotateCTM(context, radians);
    
    CGContextDrawImage(context, CGRectMake(-(width * 0.5), -(height * 0.5), width, height), self.CGImage);
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    CGContextRelease(context);
    return img;
}

- (UIImage *)pk_imageFlipHorizontal:(BOOL)horizontal vertical:(BOOL)vertical {
    if (!self.CGImage) return nil;
    size_t width = (size_t)CGImageGetWidth(self.CGImage);
    size_t height = (size_t)CGImageGetHeight(self.CGImage);
    size_t bytesPerRow = width * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    UInt8 *data = (UInt8 *)CGBitmapContextGetData(context);
    if (!data) {
        CGContextRelease(context);
        return nil;
    }
    vImage_Buffer src = { data, height, width, bytesPerRow };
    vImage_Buffer dest = { data, height, width, bytesPerRow };
    if (vertical) {
        vImageVerticalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    if (horizontal) {
        vImageHorizontalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    return img;
}

- (UIImage *)pk_imageByFlipHorizontal {
    return [self pk_imageFlipHorizontal:YES vertical:NO];
}

- (UIImage *)pk_imageByFlipVertical {
    return [self pk_imageFlipHorizontal:NO vertical:YES];
}

- (UIImage *)pk_imageByRotate180 {
    return [self pk_imageFlipHorizontal:YES vertical:YES];
}

- (UIImage *)pk_imageByRotateLeft90 {
    CGFloat degrees = 90 * M_PI / 180;
    return [self pk_imageByRotate:degrees fitSize:YES];
}

- (UIImage *)pk_imageByRotateRight90 {
    CGFloat degrees = -90 * M_PI / 180;
    return [self pk_imageByRotate:degrees fitSize:YES];
}

@end


@interface _PKUIImageSaveAlbumWrapper : NSObject

@property (nonatomic, copy) void (^block)(UIImage *image, NSError *error);

@end

@implementation _PKUIImageSaveAlbumWrapper

- (id)initWithBlock:(void (^)(UIImage *, NSError *))block {
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (_block) _block(image, error);
}

@end

@implementation UIImage (PKSaved)

- (void)pk_saveToAlbumFinished:(void (^)(UIImage * _Nonnull, NSError * _Nonnull))block {
    _PKUIImageSaveAlbumWrapper *wrapper = [[_PKUIImageSaveAlbumWrapper alloc] initWithBlock:block];
    UIImageWriteToSavedPhotosAlbum(self, wrapper, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

@end
