//
//  TQStockChartUtilities.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockChartUtilities.h"

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
