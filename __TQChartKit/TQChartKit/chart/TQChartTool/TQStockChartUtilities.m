//
//  TQStockChartUtilities.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockChartUtilities.h"

CGpYFromValueCallback CGpYConverterMake (CGPeakValue peak, CGRect rect, CGFloat borderWidth) {
    CGFloat factor = peak.max - peak.min; factor = (factor != 0 ? factor : 1);
    return ^(CGFloat value) {
        CGFloat proportion = fabs(peak.max - value) / factor;
        return (rect.size.height - borderWidth) * proportion + rect.origin.y + borderWidth * 0.5;
    };
}

CGFloat CGpYToValueCallback (CGPeakValue peak, CGRect rect, CGFloat pY) {
    CGFloat proportion = (pY - rect.origin.y) / rect.size.height;
    CGFloat proportionValue = (peak.max - peak.min) * proportion;
    return peak.max - proportionValue;
}

CGFloat CG_FloatIsZero(CGFloat a) {
    CGFloat _EPSILON = 0.000001;
    return (fabs(a) < _EPSILON);
}

CGFloat CG_FloatIs2fZero(CGFloat a) {
    CGFloat _EPSILON = 0.001;
    return (fabs(a) < _EPSILON);
}

CGFloat CG_FloatEqualFloat(CGFloat a, CGFloat b) {
    return (fabs(a - b) <= DBL_EPSILON);
}

CGFloat CG_RoundFloatKeep(CGFloat value, short n) {
    double factor = pow(10, n);
    return (floor(value * factor + 0.5)) / factor;
}

CGFloat CG_RoundFloatKeep2(CGFloat value) {
    return CG_RoundFloatKeep(value, 2);
}

CGFloat CG_PlainFloatKeep(CGFloat value, short n) {
    double factor = pow(10, n);
    return ((NSInteger)(value * factor)) / factor;
}

NSString* NS_StringFromFloat(CGFloat value) {
    return [NSString stringWithFormat:@"%@", @(value)];
}

NSString* NS_PercentFromFloat(CGFloat value) {
    return [NSNumberFormatter localizedStringFromNumber:@(value) numberStyle:NSNumberFormatterPercentStyle];
}

CGFloat CG_FloatFromPercent(NSString *percentString) {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterPercentStyle;
    return [formatter numberFromString:percentString].doubleValue;
}

NSString* NS_CurrencyFromFloat(CGFloat value) {
    return [NSNumberFormatter localizedStringFromNumber:@(value) numberStyle:NSNumberFormatterCurrencyStyle];
}

@implementation NSValue (TQChart)

+ (NSValue *)valueWithPeakValue:(CGPeakValue)peakValue {
    return [NSValue value:&peakValue withObjCType:@encode(CGPeakValue)];
}

- (CGPeakValue)peakValue {
    CGPeakValue peakValue;
    [self getValue:&peakValue];
    return peakValue;
}

+ (NSValue *)valueWithIndexValue:(CGIndexValue)indexValue {
    return [NSValue value:&indexValue withObjCType:@encode(CGIndexValue)];
}

- (CGIndexValue)indexValue {
    CGIndexValue indexValue;
    [self getValue:&indexValue];
    return indexValue;
}

+ (NSValue *)valueWithCandleShape:(CGCandleShape)candleShape {
    return [NSValue value:&candleShape withObjCType:@encode(CGCandleShape)];
}

- (CGCandleShape)candleShape {
    CGCandleShape candleShape;
    [self getValue:&candleShape];
    return candleShape;
}

@end
