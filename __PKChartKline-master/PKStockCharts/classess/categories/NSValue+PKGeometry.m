//
//  NSValue+PKGeometry.m
//  PKStockCharts
//
//  Created by zhanghao on 2019/7/11.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "NSValue+PKGeometry.h"

const CGPeakValue CGPeakValueZero = (CGPeakValue){0, 0};
const CGIndexValue CGIndexValueZero = (CGIndexValue){};
const CGIndexPeakValue CGIndexPeakValueZero = (CGIndexPeakValue){};
const CGCandleShape CGCandleShapeZero = (CGCandleShape){};
const CGChartScaler CGChartScalerZero = (CGChartScaler){};

CGFloat CGValidDivisor(CGFloat a) {
    return (fabs(a) < 1e-6) ? 1.0 : a;
}

CGFloat CGRatioLimit(CGFloat a) {
    return (CGFloat)MIN(1, MAX(0, a));
}

CGFloat CGPeakLimit(CGPeakValue peak, CGFloat a) {
    if (a < peak.min) a = peak.min; if (a > peak.max) a = peak.max;
    return a;
}

bool CGFloatEqualZero(CGFloat a) {
    return (fabs(a) < 1e-6);
}

bool CGFloatRoughEqualZero(CGFloat a) {
    return (fabs(a) < 1e-3);
}

bool CGFloatEqualFloat(CGFloat a, CGFloat b) {
    return CGFloatEqualZero(fabs(a - b));
}

bool CGPeakValueContainsFloat(CGPeakValue peak, CGFloat a) {
    return !(a > peak.max || a < peak.min);
}

bool CGPeakValueEqualToPeakValue(CGPeakValue peak1, CGPeakValue peak2) {
    return CGFloatEqualFloat(peak1.max, peak2.max) && CGFloatEqualFloat(peak1.min, peak2.min);
}

bool CGPeakValueContainZero(CGPeakValue peakValue) {
    return CGFloatEqualZero(peakValue.max) || CGFloatEqualZero(peakValue.min);
}

CGFloat CGPeakValueGetMidValue(CGPeakValue peak) {
    return peak.max - (peak.max - peak.min) * 0.5;
}

CGFloat CGPeakValueGetDistance(CGPeakValue peak) {
    return fabs(peak.max - peak.min) * 1.f;
}

CGPeakValue CGPeakValueTraverses(const CGPeakValue *traverses, size_t count) {
    CGPeakValue peakValue = traverses[0];
    for (NSInteger i = 1; i < count; i++) {
        CGPeakValue temp = traverses[i];
        if (temp.max > peakValue.max) peakValue.max = temp.max;
        if (temp.min < peakValue.min) peakValue.min = temp.min;
    }
    return peakValue;
}

CGPeakValue CGPeakValueSkipZeroTraverses(const CGPeakValue *traverses, size_t count) {
    CGPeakValue peakValue = traverses[0];
    for (NSInteger i = 1; i < count; i++) {
        CGPeakValue temp = traverses[i];
        if (temp.max > peakValue.max && !CGFloatEqualZero(temp.max)) peakValue.max = temp.max;
        if (temp.min < peakValue.min && !CGFloatEqualZero(temp.min)) peakValue.min = temp.min;
    }
    return peakValue;
}


CGMakeYaxisBlock CGMakeYaxisBlockCreator (CGPeakValue peakValue, CGRect rect) {
    CGFloat factor = CGValidDivisor(peakValue.max - peakValue.min);
    return ^(CGFloat value) {
        CGFloat proportion = fabs(peakValue.max - value) / factor;
        return rect.size.height * proportion + rect.origin.y;
    };
}

CGFloat CGMakeYnumberBlock (CGPeakValue peakValue, CGRect rect, CGFloat yaxis) {
    CGFloat proportion = (yaxis - rect.origin.y) / rect.size.height;
    CGFloat proportionValue = (peakValue.max - peakValue.min) * proportion;
    return peakValue.max - proportionValue;
}

CGMakeXaxisBlock CGMakeXaxisBlockCreator (CGFloat shapeWidth, CGFloat shapeGap) {
    CGFloat allWidthGap = shapeWidth + shapeGap;
    CGFloat shapeWidthHalf = half(shapeWidth);
    return ^(NSInteger idx) {
        return allWidthGap * idx + shapeWidthHalf;
    };
}

NSInteger CGMakeXindexBlock (CGFloat shapeWidth, CGFloat shapeGap, CGFloat dataCount, CGFloat xaxis) {
    CGFloat shapeOne = shapeWidth + shapeGap;
    NSInteger index = xaxis / shapeOne;
    CGFloat baseline = index * shapeOne + shapeOne - half(shapeGap);
    if (xaxis > baseline) index += 1;
    index = MAX(0, index);
    index = MIN(dataCount - 1, index);
    return index;
}


@implementation NSValue (PKGeometry)

+ (NSValue *)pk_valueWithPeakValue:(CGPeakValue)peakValue {
    return [NSValue value:&peakValue withObjCType:@encode(CGPeakValue)];
}

- (CGPeakValue)pk_peakValue {
    CGPeakValue peakValue;
    [self getValue:&peakValue];
    return peakValue;
}

+ (NSValue *)pk_valueWithIndexValue:(CGIndexValue)indexValue {
    return [NSValue value:&indexValue withObjCType:@encode(CGIndexValue)];
}

- (CGIndexValue)pk_indexValue {
    CGIndexValue indexValue;
    [self getValue:&indexValue];
    return indexValue;
}

+ (NSValue *)pk_valueWithIndexPeakValue:(CGIndexPeakValue)indexPeakValue {
    return [NSValue value:&indexPeakValue withObjCType:@encode(CGIndexPeakValue)];
}

- (CGIndexPeakValue)pk_indexPeakValue {
    CGIndexPeakValue indexPeakValue;
    [self getValue:&indexPeakValue];
    return indexPeakValue;
}

+ (NSValue *)pk_valueWithCandleShape:(CGCandleShape)candleShape {
    return [NSValue value:&candleShape withObjCType:@encode(CGCandleShape)];
}

- (CGCandleShape)pk_candleShape {
    CGCandleShape candleShape;
    [self getValue:&candleShape];
    return candleShape;
}

+ (NSValue *)pk_valueWithChartScaler:(CGChartScaler)chartScaler {
    return [NSValue value:&chartScaler withObjCType:@encode(CGChartScaler)];
}

- (CGChartScaler)pk_chartScaler {
    CGChartScaler chartScaler;
    [self getValue:&chartScaler];
    return chartScaler;
}

@end
