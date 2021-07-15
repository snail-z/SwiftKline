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

+ (NSArray<NSString *> *)tq_partitionWithPeak:(CGPeakValue)peak
                                     segments:(NSUInteger)segments
                                       format:(NSString *)format
                                 attachedText:(NSString *)attachedText {
    NSMutableArray<NSString *> *array = [NSMutableArray array];
    CGFloat section = fabs(peak.max - peak.min) / (CGFloat)segments;
    for (NSInteger i = 0; i <= segments; i++) {
        NSString *text = [NSString stringWithFormat:format, peak.max - section * i];
        if (attachedText) text = [text stringByAppendingString:attachedText];
        [array addObject:text];
    }
    return array.copy;
}

+ (NSArray<NSString *> *)tq_partition2fWithPeak:(CGPeakValue)peak
                                       segments:(NSUInteger)segments {
    NSMutableArray<NSString *> *array = [NSMutableArray array];
    CGFloat split = fabs(peak.max - peak.min) / (CGFloat)segments;
    for (NSInteger i = 0; i <= segments; i++) {
        NSString *text = [NSString stringWithFormat:@"%.2f", peak.max - split * i];
        [array addObject:text];
    }
    return array.copy;
}

@end
