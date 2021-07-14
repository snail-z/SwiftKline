//
//  TQStockChartUtilities.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockChartUtilities.h"

CGaxisYConverBlock CGaxisYConverMaker (CGPeakValue peak, CGRect rect, CGFloat borderWidth) {
    CGFloat factor = peak.max - peak.min; factor = (factor != 0 ? factor : 1);
    CGFloat halfBorderWidth = half(borderWidth);
    CGFloat realHeight = rect.size.height - borderWidth;
    return ^(CGFloat value) {
        CGFloat proportion = fabs(peak.max - value) / factor;
        return realHeight * proportion + rect.origin.y + halfBorderWidth;
    };
}

CGFloat CGaxisYToValueBlock (CGPeakValue peak, CGRect rect, CGFloat axisY) {
    CGFloat proportion = (axisY - rect.origin.y) / rect.size.height;
    CGFloat proportionValue = (peak.max - peak.min) * proportion;
    return peak.max - proportionValue;
}

CGaxisXConverBlock CGaxisXConverMaker (CGFloat shapeWidth, CGFloat shapeGap) {
    CGFloat halfShapeWidth = half(shapeWidth);
    CGFloat allWidthGap = shapeWidth + shapeGap;
    return ^(NSInteger idx) {
        return allWidthGap * idx + halfShapeWidth;
    };
}

CGFloat CGaxisXToIndexBlock (CGFloat axisX, CGFloat shapeWidth, CGFloat shapeGap, NSUInteger dataCount) {
    CGFloat shapeOne = shapeWidth + shapeGap;
    NSInteger index = axisX / shapeOne;
    CGFloat baseline = index * shapeOne + shapeOne - half(shapeGap);
    if (axisX > baseline) index += 1;
    index = MAX(0, index);
    index = MIN(dataCount - 1, index);
    return index;
}

/////////////////////////////////////////////////////////////////

CGPeakValue CG_CheckPeakValue(CGPeakValue peak, NSString *description) {
    if (CG_PeakEqualToPeak(peak, CGPeakValueZero)) {
        NSLog(@"%@", [NSString stringWithFormat:@"[%@] {max = %@, min = %@} 绘制失败，原因最大最小值不存在!", description, @(peak.max), @(peak.min)]);
    } else if (CG_FloatIsZero(CG_GetPeakDistance(peak))) {
        NSLog(@"%@", [NSString stringWithFormat:@"[%@] {max = %@, min = %@} 绘制失败，原因最大最小值相等!", description, @(peak.max), @(peak.min)]);
    }
    return peak;
}

CGPeakValue CG_TraversePeakValues(const CGPeakValue *traverses, size_t count) {
    CGPeakValue peakValue = traverses[0];
    for (NSInteger i = 1; i < count; i++) {
        CGPeakValue temp = traverses[i];
        if (temp.max > peakValue.max) peakValue.max = temp.max;
        if (temp.min < peakValue.min) peakValue.min = temp.min;
    }
    return peakValue;
}

CGPeakValue CG_TraverseSkipZeroPeakValues(const CGPeakValue *traverses, size_t count) {
    CGPeakValue peakValue = traverses[0];
    for (NSInteger i = 1; i < count; i++) {
        CGPeakValue temp = traverses[i];
        if (temp.max > peakValue.max && !CG_FloatIsZero(temp.max)) peakValue.max = temp.max;
        if (temp.min < peakValue.min && !CG_FloatIsZero(temp.min)) peakValue.min = temp.min;
    }
    return peakValue;
}

/////////////////////////////////////////////////////////////////

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

CGFloat CG_PlainFloatKeep(CGFloat value, short n) {
    double factor = pow(10, n);
    return ((NSInteger)(value * factor)) / factor;
}

NSString* NS_StringFromPlainFloatKeep(CGFloat value, short n) {
    NSString *format = [NSString stringWithFormat:@"%%.%@f", @(n)];
    return [NSString stringWithFormat:format, CG_PlainFloatKeep(value, n)];
}

NSString* NS_StringFromPlainFloatKeep2(CGFloat value) {
    return [NSString stringWithFormat:@"%.2f", CG_PlainFloatKeep(value, 2)];
}

NSString* NS_StringFromRoundFloatKeep(CGFloat value, short n) {
    NSString *format = [NSString stringWithFormat:@"%%.%@f", @(n)];
    return [NSString stringWithFormat:format, CG_RoundFloatKeep(value, n)];
}

NSString* NS_StringFromRoundFloatKeep2(CGFloat value) {
    return [NSString stringWithFormat:@"%.2f", CG_RoundFloatKeep(value, 2)];
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

/////////////////////////////////////////////////////////////////

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
