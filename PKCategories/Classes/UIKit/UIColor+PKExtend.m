//
//  UIColor+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UIColor+PKExtend.h"

@implementation UIColor (PKExtend)

+ (UIColor *)pk_colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a {
    return [self colorWithRed:r / 255. green:g / 255. blue:b / 255. alpha:a / 255.];
}

+ (UIColor *)pk_colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b {
    return [self pk_colorWithRed:r green:g blue:b alpha:0xff];
}

+ (UIColor *)pk_colorWithHexRGBA:(NSUInteger)rgbaValue {
    return [UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24) / 255.0f
                           green:((rgbaValue & 0xFF0000) >> 16) / 255.0f
                            blue:((rgbaValue & 0xFF00) >> 8) / 255.0f
                           alpha:(rgbaValue & 0xFF) / 255.0f];
}

+ (UIColor *)pk_colorWithHexRGB:(NSUInteger)rgbValue {
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1];
}

+ (UIColor *)pk_colorWithHexString:(NSString *)hexString {
    if (!hexString) return nil;
    NSString *hex = [NSString stringWithString:hexString];
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    if (hex.length == 6) {
        hex = [hex stringByAppendingString:@"FF"];
    } else if (hex.length != 8) {
        return nil;
    }
    uint32_t rgba;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&rgba];
    return [UIColor pk_colorWithHexRGBA:rgba];
}

- (NSUInteger)pk_hexRGBAValue {
    CGFloat r = 0.0, g = 0.0, b = 0.0, a = 0.0;
    if ([self getRed:&r green:&g blue:&b alpha:&a]) {
        NSUInteger red = (NSUInteger)(r * 255 + 0.5);
        NSUInteger green = (NSUInteger)(g * 255 + 0.5);
        NSUInteger blue = (NSUInteger)(b * 255 + 0.5);
        NSUInteger alpha = (NSUInteger)(a * 255 + 0.5);
        return (red << 24) + (green << 16) + (blue << 8) + alpha;
    }
    return 0;
}

- (NSUInteger)pk_hexRGBValue {
    CGFloat r = 0.0, g = 0.0, b = 0.0, a = 0.0;
    if ([self getRed:&r green:&g blue:&b alpha:&a]) {
        NSUInteger red = (NSUInteger)(r * 255 + 0.5);
        NSUInteger green = (NSUInteger)(g * 255 + 0.5);
        NSUInteger blue = (NSUInteger)(b * 255 + 0.5);
        return (red << 16) + (green << 8) + blue;
    }
    return 0;
}

- (NSArray<NSNumber *> *)pk_RGBAValues {
    CGFloat r = 0.0, g = 0.0, b = 0.0, a = 0.0;
    if ([self getRed:&r green:&g blue:&b alpha:&a]) {
        NSUInteger red = (NSUInteger)(r * 255 + 0.5);
        NSUInteger green = (NSUInteger)(g * 255 + 0.5);
        NSUInteger blue = (NSUInteger)(b * 255 + 0.5);
        return @[@(red), @(green), @(blue), @(a)];
    }
    return @[@(0), @(0), @(0), @(0)];
}

- (NSString *)pk_hexString {
    return [self pk_hexStringWithAlpha:NO];
}

- (NSString *)pk_hexStringWithAlpha {
    return [self pk_hexStringWithAlpha:YES];
}

- (NSString *)pk_hexStringWithAlpha:(BOOL)withAlpha {
    CGColorRef color = self.CGColor;
    size_t count = CGColorGetNumberOfComponents(color);
    const CGFloat *components = CGColorGetComponents(color);
    static NSString *stringFormat = @"%02x%02x%02x";
    NSString *hex = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)(components[0] * 255.0f);
        hex = [NSString stringWithFormat:stringFormat, white, white, white];
    } else if (count == 4) {
        hex = [NSString stringWithFormat:stringFormat,
               (NSUInteger)(components[0] * 255.0f),
               (NSUInteger)(components[1] * 255.0f),
               (NSUInteger)(components[2] * 255.0f)];
    }
    if (hex && withAlpha) {
        hex = [hex stringByAppendingFormat:@"%02lx",
               (unsigned long)(self.pk_alphaValue * 255.0 + 0.5)];
    }
    return hex;
}

- (CGFloat)pk_alphaValue {
    return CGColorGetAlpha(self.CGColor);
}

+ (UIColor *)pk_systemBlueColor {
    return [UIColor colorWithRed:0 / 255. green:122 / 255. blue:255 / 255. alpha:1];
}

+ (UIColor *)pk_separatorLineColor {
    return [UIColor colorWithRed:220 / 255. green:220 / 255. blue:220 / 255. alpha:1];
}

+ (UIColor *)pk_randomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    return [UIColor colorWithRed:aRedValue / 255.f green:aGreenValue / 255.f blue:aBlueValue / 255.f alpha:1.f];
}

@end
