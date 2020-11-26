//
//  NSMutableAttributedString+PKStockChart.m
//  PKChartKit
//
//  Created by zhanghao on 2017/12/28.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "NSMutableAttributedString+PKStockChart.h"
#import <CoreText/CoreText.h>

@implementation NSMutableAttributedString (PKStockChart)

#pragma mark - getter

- (NSDictionary *)pk_attributes {
    return [self pk_attributesAtIndex:0];
}

- (NSDictionary *)pk_attributesAtIndex:(NSUInteger)index {
    if (index > self.length || self.length == 0) return nil;
    if (self.length > 0 && index == self.length) index--;
    return [self attributesAtIndex:index effectiveRange:NULL];
}

- (id)pk_getAttribute:(NSString *)attributeName atIndex:(NSUInteger)index {
    if (!attributeName) return nil;
    if (index > self.length || self.length == 0) return nil;
    if (self.length > 0 && index == self.length) index--;
    return [self attribute:attributeName atIndex:index effectiveRange:NULL];
}

- (UIFont *)pk_fontAtIndex:(NSUInteger)index {
    return [self pk_getAttribute:NSFontAttributeName atIndex:index];
}

- (UIColor *)pk_colorAtIndex:(NSUInteger)index {
    UIColor *color = [self pk_getAttribute:NSForegroundColorAttributeName atIndex:index];
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self pk_getAttribute:(NSString *)kCTForegroundColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    if (color && ![color isKindOfClass:[UIColor class]]) {
        if (CFGetTypeID((__bridge CFTypeRef)(color)) == CGColorGetTypeID()) {
            color = [UIColor colorWithCGColor:(__bridge CGColorRef)(color)];
        } else {
            color = nil;
        }
    }
    return color;
}

- (UIColor *)pk_backgroundColorAtIndex:(NSUInteger)index {
    return [self pk_getAttribute:NSBackgroundColorAttributeName atIndex:index];
}

- (NSNumber *)pk_kernAtIndex:(NSUInteger)index {
    return [self pk_getAttribute:NSKernAttributeName atIndex:index];
}

- (NSNumber *)pk_baselineOffsetAtIndex:(NSUInteger)index {
    return [self pk_getAttribute:NSBaselineOffsetAttributeName atIndex:index];
}

- (NSNumber *)pk_strokeWidthAtIndex:(NSUInteger)index {
    return [self pk_getAttribute:NSStrokeWidthAttributeName atIndex:index];
}

- (UIColor *)pk_strokeColorAtIndex:(NSUInteger)index {
    UIColor *color = [self pk_getAttribute:NSStrokeColorAttributeName atIndex:index];
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self pk_getAttribute:(NSString *)kCTStrokeColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    return color;
}

- (NSShadow *)pk_shadowAtIndex:(NSUInteger)index {
    return [self pk_getAttribute:NSShadowAttributeName atIndex:index];
}

- (UIFont *)pk_font {
    return [self pk_fontAtIndex:0];
}

- (UIColor *)pk_foregroundColor {
    return [self pk_colorAtIndex:0];
}

- (UIColor *)pk_backgroundColor {
    return [self pk_backgroundColorAtIndex:0];
}

- (NSNumber *)pk_kern {
    return [self pk_kernAtIndex:0];
}

- (NSNumber *)pk_baselineOffset {
    return [self pk_baselineOffsetAtIndex:0];
}

- (NSNumber *)pk_strokeWidth {
    return [self pk_strokeWidthAtIndex:0];
}

- (UIColor *)pk_strokeColor {
    return [self pk_strokeColorAtIndex:0];
}

- (NSShadow *)pk_shadow {
    return [self pk_shadowAtIndex:0];
}

#pragma mark - setter

- (void)pk_setAttributes:(NSDictionary *)attributes {
    if (attributes == (id)[NSNull null]) attributes = nil;
    [self setAttributes:@{} range:NSMakeRange(0, self.length)];
    [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self pk_setAttribute:key value:obj];
    }];
}

- (void)pk_setAttribute:(NSString *)name value:(id)value {
    [self pk_setAttribute:name value:value range:NSMakeRange(0, self.length)];
}

- (void)pk_setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) return;
    if (value && ![NSNull isEqual:value]) [self addAttribute:name value:value range:range];
    else [self removeAttribute:name range:range];
}

- (void)pk_setFont:(UIFont *)font range:(NSRange)range {
    [self pk_setAttribute:NSFontAttributeName value:font range:range];
}

- (void)pk_setForegroundColor:(UIColor *)color range:(NSRange)range {
    [self pk_setAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
    [self pk_setAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)pk_setBackgroundColor:(UIColor *)backgroundColor range:(NSRange)range {
    [self pk_setAttribute:NSBackgroundColorAttributeName value:backgroundColor range:range];
}

- (void)pk_setKern:(NSNumber *)kern range:(NSRange)range {
    [self pk_setAttribute:NSKernAttributeName value:kern range:range];
}

- (void)pk_setBaselineOffset:(NSNumber *)baselineOffset range:(NSRange)range {
    [self pk_setAttribute:NSBaselineOffsetAttributeName value:baselineOffset range:range];
}

- (void)pk_setParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range {
    [self pk_setAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}

- (void)pk_setStrokeWidth:(NSNumber *)strokeWidth range:(NSRange)range {
    [self pk_setAttribute:NSStrokeWidthAttributeName value:strokeWidth range:range];
}

- (void)pk_setStrokeColor:(UIColor *)strokeColor range:(NSRange)range {
    [self pk_setAttribute:(id)kCTStrokeColorAttributeName value:(id)strokeColor.CGColor range:range];
    [self pk_setAttribute:NSStrokeColorAttributeName value:strokeColor range:range];
}

- (void)pk_setShadow:(NSShadow *)shadow range:(NSRange)range {
    [self pk_setAttribute:NSShadowAttributeName value:shadow range:range];
}

- (void)pk_setFont:(UIFont *)font {
    [self pk_setFont:font range:NSMakeRange(0, self.length)];
}

- (void)pk_setForegroundColor:(UIColor *)foregroundColor {
    [self pk_setForegroundColor:foregroundColor range:NSMakeRange(0, self.length)];
}

- (void)pk_setBackgroundColor:(UIColor *)backgroundColor {
    [self pk_setBackgroundColor:backgroundColor range:NSMakeRange(0, self.length)];
}

- (void)pk_setKern:(NSNumber *)kern {
    [self pk_setKern:kern range:NSMakeRange(0, self.length)];
}

- (void)pk_setBaselineOffset:(NSNumber *)baselineOffset {
    [self pk_setBaselineOffset:baselineOffset range:NSMakeRange(0, self.length)];
}

- (void)pk_setStrokeWidth:(NSNumber *)strokeWidth {
    [self pk_setStrokeWidth:strokeWidth range:NSMakeRange(0, self.length)];
}

- (void)pk_setStrokeColor:(UIColor *)strokeColor {
    [self pk_setStrokeColor:strokeColor range:NSMakeRange(0, self.length)];
}

- (void)pk_setShadow:(NSShadow *)shadow {
    [self pk_setShadow:shadow range:NSMakeRange(0, self.length)];
}

- (void)pk_setParagraphStyle:(NSParagraphStyle *)paragraphStyle {
    [self pk_setParagraphStyle:paragraphStyle range:NSMakeRange(0, self.length)];
}

+ (instancetype)pk_attributedWithString:(NSString *)aString {
    return [[NSMutableAttributedString alloc] initWithString:aString];
}

@end
