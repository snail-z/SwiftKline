//
//  NSArray+TQStockChart.m
//  TQChartKit
//
//  Created by zhanghao on 2018/8/29.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "NSArray+TQStockChart.h"

@implementation NSArray (TQStockChart)

- (void)enumerateObjsAtRange:(NSRange)range ceaselessBlock:(void (^)(id _Nonnull, NSUInteger))block {
    NSInteger length = NSMaxRange(range);
    if (length > self.count) return;
    for (NSInteger idx = range.location; idx < length; idx++) {
        block(self[idx], idx);
    }
}

- (void)enumerateObjsAtRange:(NSRange)range usingBlock:(void (^)(id _Nonnull, NSUInteger, BOOL * _Nonnull))block {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self enumerateObjectsAtIndexes:indexSet options:kNilOptions usingBlock:block];
}

- (id)firstObjInRange:(NSRange)range {
    if (range.location < self.count) return self[range.location];
    return nil;
}

- (id)lastObjInRange:(NSRange)range {
    NSUInteger lastIndex = NSMaxRange(range) - 1;
    if (lastIndex < self.count) return self[lastIndex];
    return nil;
}

- (NSInteger)lastIdx {
    if (!self.count) return 0;
    return self.count - 1;
}

- (NSInteger)middleIdx {
    return (NSInteger)((0 + self.lastIdx) / 2);
}

- (CGPeakValue)peakValueBySel:(SEL)sel {
    if (!self.count) return CGPeakValueZero;
    IMP imp = [self.lastObject methodForSelector:sel];
    CGFloat(*msgSend)(id, SEL) = (void*)imp;
    CGPeakValue peakValue = CGPeakValueMake(-CGFLOAT_MAX, CGFLOAT_MAX);
    for (id obj in self) {
        CGFloat tempValue = msgSend(obj, sel);
        if (tempValue > peakValue.max) peakValue.max = tempValue;
        if (tempValue < peakValue.min) peakValue.min = tempValue;
    }
    return peakValue;
}

- (CGPeakValue)peakValueWithRange:(NSRange)range bySel:(SEL)sel {
    if (!self.count) return CGPeakValueZero;
    IMP imp = [self.lastObject methodForSelector:sel];
    CGFloat(*msgSend)(id, SEL) = (void*)imp;
    __block CGPeakValue peakValue = CGPeakValueMake(-CGFLOAT_MAX, CGFLOAT_MAX);
    [self enumerateObjsAtRange:range ceaselessBlock:^(id  _Nonnull obj, NSUInteger idx) {
        CGFloat tempValue = msgSend(obj, sel);
        if (tempValue > peakValue.max) peakValue.max = tempValue;
        if (tempValue < peakValue.min) peakValue.min = tempValue;
    }];
    return peakValue;
}

- (CGPeakValue)peakValueWithEvaluatedBlock:(CGFloat (NS_NOESCAPE^)(id _Nonnull))block {
    if (!self.count) return CGPeakValueZero;
    CGPeakValue peakValue = CGPeakValueMake(-CGFLOAT_MAX, CGFLOAT_MAX);
    for (id obj in self) {
        CGFloat tempValue = block(obj);
        if (tempValue > peakValue.max) peakValue.max = tempValue;
        if (tempValue < peakValue.min) peakValue.min = tempValue;
    }
    return peakValue;
}

- (CGPeakValue)peakValueWithRange:(NSRange)range evaluatedBlock:(CGFloat (^NS_NOESCAPE)(id _Nonnull))block {
    if (!self.count) return CGPeakValueZero;
    __block CGPeakValue peakValue = CGPeakValueMake(-CGFLOAT_MAX, CGFLOAT_MAX);
    [self enumerateObjsAtRange:range ceaselessBlock:^(id  _Nonnull obj, NSUInteger idx) {
        CGFloat tempValue = block(obj);
        if (tempValue > peakValue.max) peakValue.max = tempValue;
        if (tempValue < peakValue.min) peakValue.min = tempValue;
    }];
    return peakValue;
}

- (CGPeakValue)peakValueSkipZeroWithRange:(NSRange)range evaluatedBlock:(CGFloat (^NS_NOESCAPE)(id _Nonnull))block {
    if (!self.count) return CGPeakValueZero;
    __block CGPeakValue peakValue = CGPeakValueMake(-CGFLOAT_MAX, CGFLOAT_MAX);
    [self enumerateObjsAtRange:range ceaselessBlock:^(id  _Nonnull obj, NSUInteger idx) {
        CGFloat tempValue = block(obj);
        if (tempValue > peakValue.max && !CG_FloatIsZero(tempValue)) peakValue.max = tempValue;
        if (tempValue < peakValue.min && !CG_FloatIsZero(tempValue)) peakValue.min = tempValue;
    }];
    return peakValue;
}

- (CGPeakIndexValue)peakIndexValueWithRange:(NSRange)range evaluatedBlock:(CGFloat (^NS_NOESCAPE)(id _Nonnull))block {
    __block CGIndexValue maxValue = CGIndexValueMake(0, -CGFLOAT_MAX);
    __block CGIndexValue minValue = CGIndexValueMake(0, CGFLOAT_MAX);
    [self enumerateObjsAtRange:range ceaselessBlock:^(id  _Nonnull obj, NSUInteger idx) {
        CGFloat tempValue = block(obj);
        if (tempValue > maxValue.value) maxValue = CGIndexValueMake(idx, tempValue);
        if (tempValue < minValue.value) minValue = CGIndexValueMake(idx, tempValue);
    }];
    return CGPeakIndexValueMake(maxValue, minValue);
}

- (CGFloat)sumCalculation:(NSUInteger)idx length:(NSUInteger)length evaluatedBlock:(CGFloat (^NS_NOESCAPE)(id _Nonnull))block {
    NSRange range = idx < length ? NSMakeRange(0, idx + 1) : NSMakeRange(idx - length + 1, length);
    __block  CGFloat sum = 0;
    [self enumerateObjsAtRange:range ceaselessBlock:^(id  _Nonnull obj, NSUInteger idx) {
        sum += block(obj);
    }];
    return sum;
}

- (CGFloat)productCalculation:(NSUInteger)idx length:(NSUInteger)length evaluatedBlock:(CGFloat (^NS_NOESCAPE)(id _Nonnull))block {
    NSRange range = idx < length ? NSMakeRange(0, idx + 1) : NSMakeRange(idx - length + 1, length);
    __block  CGFloat sum = 0;
    [self enumerateObjsAtRange:range ceaselessBlock:^(id  _Nonnull obj, NSUInteger idx) {
        sum *= block(obj);
    }];
    return sum;
}

- (NSUInteger)timesCalculation:(NSUInteger)idx length:(NSUInteger)length conditionBlock:(BOOL (^NS_NOESCAPE)(id _Nonnull))block {
    NSRange range = idx < length ? NSMakeRange(0, idx + 1) : NSMakeRange(idx - length + 1, length);
    __block  NSUInteger times = 0;
    [self enumerateObjsAtRange:range ceaselessBlock:^(id  _Nonnull obj, NSUInteger idx) {
        if (block(obj)) times++;
    }];
    return times;
}

- (CGFloat)ssdCalculation:(NSUInteger)idx length:(NSUInteger)length avg:(CGFloat)avgValue evaluatedBlock:(CGFloat (^NS_NOESCAPE)(id _Nonnull))block {
    NSRange range = idx < length ? NSMakeRange(0, idx + 1) : NSMakeRange(idx - length + 1, length);
    __block CGFloat varianceValue = 0;
    [self enumerateObjsAtRange:range ceaselessBlock:^(id  _Nonnull obj, NSUInteger idx) {
        CGFloat eachValue = block(obj);
        varianceValue += pow((eachValue - avgValue), 2);
    }];
    NSInteger sample = length < self.count ? (length - 1) : length;
    return sqrt(varianceValue / (sample * 1.f));
}

- (void)enumerateCalculateMA:(NSUInteger)length range:(NSRange)range evaluatedBlock:(CGFloat (^NS_NOESCAPE)(id _Nonnull))block usingBlock:(void (^NS_NOESCAPE)(NSUInteger, CGFloat))resultBlock {
    __block CGFloat sum = 0.f;
    void (^callback)(NSInteger) = ^(NSInteger start) {
        NSInteger max = NSMaxRange(range);
        for (NSInteger idx = start; idx < max; idx++) {
            CGFloat currentValue = block(self[idx]);
            sum += currentValue;
            CGFloat clearValue = block(self[idx - length]);
            sum -= clearValue;
            resultBlock(idx, sum / length);
        }
    };
    if (range.location < length) {
        NSInteger endIndex = length - 1;
        for (NSInteger i = 0; i < endIndex; i++) {
            sum += block(self[i]);
            resultBlock(i, 0);
        }
        sum += block(self[endIndex]);
        resultBlock(endIndex, sum / length);
        callback(length);
    } else {
        NSInteger endIndex = range.location - length;
        for (NSInteger i = range.location; i > endIndex; i--) {
            sum += block(self[i]);
        }
        resultBlock(range.location, sum / length);
        callback(range.location + 1);
    }
}

@end

@implementation NSArray (TQStockChartStatic)

+ (NSArray<NSString *> *)arrayWithPartition:(NSInteger)partitions peakValue:(CGPeakValue)peakValue {
    NSMutableArray<NSString *> *mutableArray = [NSMutableArray array];
    CGFloat segments = fabs(peakValue.max - peakValue.min) / (CGFloat)partitions;
    for (NSInteger i = 0; i <= partitions; i++) {
        [mutableArray addObject:[NSString stringWithFormat:@"%.2f", peakValue.max - segments * i]];
    }
    return mutableArray.copy;
}

+ (NSArray<NSString *> *)arrayWithPartition:(NSInteger)partitions peakValue:(CGPeakValue)peakValue resultBlock:(NSString * _Nonnull (NS_NOESCAPE^)(CGFloat, NSUInteger))block {
    NSMutableArray<NSString *> *mutableArray = [NSMutableArray array];
    CGFloat segments = fabs(peakValue.max - peakValue.min) / (CGFloat)partitions;
    for (NSInteger i = 0; i <= partitions; i++) {
        CGFloat floatValue = peakValue.max - (CGFloat)segments * i;
        [mutableArray addObject:block(floatValue, i)];
    }
    return mutableArray.copy;
}

@end
