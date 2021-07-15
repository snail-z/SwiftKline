//
//  UIColor+zhExtend.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/3.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIColor+zhExtend.h"

@implementation UIColor (zhExtend)

+ (UIColor *)zh_r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b a:(uint8_t)a {
    return [self colorWithRed:r / 255. green:g / 255. blue:b / 255. alpha:a / 255.];
}

+ (UIColor *)zh_r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b {
    return [self zh_r:r g:g b:b a:0xff];
}

+ (UIColor *)zh_rgba:(NSUInteger)rgba {
    return [self zh_r:(rgba >> 24)&0xFF g:(rgba >> 16)&0xFF b:(rgba >> 8)&0xFF a:rgba&0xFF];
}

+ (UIColor *)zh_randomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.f green:aGreenValue / 255.f blue:aBlueValue / 255.f alpha:1.f];
    return randColor;
}

- (NSUInteger)zh_rgbaValue {
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a]) {
        NSUInteger rr = (NSUInteger)(r * 255 + 0.5);
        NSUInteger gg = (NSUInteger)(g * 255 + 0.5);
        NSUInteger bb = (NSUInteger)(b * 255 + 0.5);
        NSUInteger aa = (NSUInteger)(a * 255 + 0.5);
        return (rr << 24) | (gg << 16) | (bb << 8) | aa;
    } else {
        return 0;
    }
}

+ (UIColor *)zh_colorWithHexString:(NSString *)hexString {
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
    return [UIColor zh_rgba:rgba];
}

- (NSString *)zh_hexString {
    return [self zh_hexStringWithAlpha:NO];
}

- (NSString *)zh_hexStringWithAlpha {
    return [self zh_hexStringWithAlpha:YES];
}

- (NSString *)zh_hexStringWithAlpha:(BOOL)withAlpha {
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
               (unsigned long)(self.zh_alpha * 255.0 + 0.5)];
    }
    return hex;
}

- (CGFloat)zh_alpha {
    return CGColorGetAlpha(self.CGColor);
}

@end
