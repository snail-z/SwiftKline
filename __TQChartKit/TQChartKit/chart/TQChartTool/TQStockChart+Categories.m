//
//  TQStockChart+Categories.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockChart+Categories.h"

@implementation NSArray (TQStockChart)

- (void)tq_enumerateObjectsAtRange:(NSRange)range usingBlock:(void (^)(id _Nonnull, NSUInteger, BOOL * _Nonnull))block {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self enumerateObjectsAtIndexes:indexSet options:kNilOptions usingBlock:block];
}

- (id)tq_firstObjectAtRange:(NSRange)range {
    if (range.location < self.count) {
        return self[range.location];
    }
    return nil;
}

- (id)tq_lastObjectAtRange:(NSRange)range {
    NSInteger lastIndex = NSMaxRange(range) - 1;
    if (lastIndex < self.count) {
        return self[lastIndex];
    }
    return nil;
}

- (NSInteger)tq_lastIndex {
    if (self.count) {
        return self.count - 1;
    }
    return 0;
}

- (NSInteger)tq_middleIndex {
    if (self.count % 2) {
        return (0 + self.tq_lastIndex) / 2;
    }
    return 0;
}

- (CGPeakValue)tq_peakValue {
    if (self.count <= 0) return CGPeakValueZero;
    id obj = self.lastObject;
    if (![obj isKindOfClass:[NSNumber class]] && ![obj isKindOfClass:[NSString class]]) return CGPeakValueZero;
    CGPeakValue peak = CGPeakValueMake(CGFLOAT_MIN, CGFLOAT_MAX);
    for (NSNumber *obj in self) {
        CGFloat tempValue = obj.doubleValue;
        if (tempValue > peak.max) peak.max = tempValue;
        if (tempValue < peak.min) peak.min = tempValue;
    }
    return peak;
}

- (CGPeakValue)tq_peakValueBySel:(SEL)sel {
    if (self.count <= 0) return CGPeakValueZero;
    IMP imp = [self.lastObject methodForSelector:sel];
    CGFloat(*msgSend)(id, SEL) = (void*)imp;
    CGPeakValue peak = CGPeakValueMake(CGFLOAT_MIN, CGFLOAT_MAX);
    for (id obj in self) {
        CGFloat tempValue = msgSend(obj, sel);
        if (tempValue > peak.max) peak.max = tempValue;
        if (tempValue < peak.min) peak.min = tempValue;
    }
    return peak;
}

- (CGPeakValue)tq_peakValueWithRange:(NSRange)range bySel:(SEL)sel {
    if (self.count <= 0) return CGPeakValueZero;
    IMP imp = [self.lastObject methodForSelector:sel];
    CGFloat(*msgSend)(id, SEL) = (void*)imp;
    __block CGPeakValue peak = CGPeakValueMake(CGFLOAT_MIN, CGFLOAT_MAX);
    [self tq_enumerateObjectsAtRange:range usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat tempValue = msgSend(obj, sel);
        if (tempValue > peak.max) peak.max = tempValue;
        if (tempValue < peak.min) peak.min = tempValue;
    }];
    return peak;
}

+ (NSArray<NSString *> *)tq_segmentedGrid:(NSInteger)segments peakValue:(CGPeakValue)peakValue {
    NSMutableArray<NSString *> *array = [NSMutableArray array];
    CGFloat split = fabs(peakValue.max - peakValue.min) / (CGFloat)segments;
    for (NSInteger i = 0; i <= segments; i++) {
        NSString *string = [NSString stringWithFormat:@"%.2f", peakValue.max - split * i];
        [array addObject:string];
    }
    return array.copy;
}

+ (NSArray<NSString *> *)tq_gridSegments:(NSInteger)segments peakValue:(CGPeakValue)peakValue attached:(NSString *)attached {
    NSMutableArray<NSString *> *array = [NSMutableArray array];
    CGFloat split = fabs(peakValue.max - peakValue.min) / (CGFloat)segments;
    for (NSInteger i = 0; i <= segments; i++) {
        NSString *string = [NSString stringWithFormat:@"%.2f", peakValue.max - split * i];
        string = [string stringByAppendingString:attached];
        [array addObject:string];
    }
    return array.copy;
}

@end
