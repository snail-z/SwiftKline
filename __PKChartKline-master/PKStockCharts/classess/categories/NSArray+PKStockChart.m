//
//  NSArray+PKStockChart.m
//  PKChartKit
//
//  Created by zhanghao on 2017/11/28.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "NSArray+PKStockChart.h"

@implementation NSArray (PKStockChart)

- (void)pk_enumerateIndexsCeaselessBlock:(void (^ NS_NOESCAPE )(NSUInteger))block {
    NSInteger count = self.count;
    for (NSInteger idx = 0; idx < count; idx++) {
        block(idx);
    }
}

- (void)pk_enumerateObjsCeaselessBlock:(void (^ NS_NOESCAPE)(id _Nonnull, NSUInteger))block {
    NSInteger idx = 0;
    for (id obj in self) {
        block(obj, idx); idx++;
    }
}

- (void)pk_enumerateObjsAtRange:(NSRange)range ceaselessBlock:(void (^ NS_NOESCAPE)(id _Nonnull, NSUInteger))block {
    NSInteger length = NSMaxRange(range);
    if (length > self.count) return;
    for (NSInteger idx = range.location; idx < length; idx++) {
        block(self[idx], idx);
    }
}

- (void)pk_enumerateObjsAtRange:(NSRange)range usingBlock:(void (^ NS_NOESCAPE)(id _Nonnull, NSUInteger, BOOL * _Nonnull))block {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self enumerateObjectsAtIndexes:indexSet options:kNilOptions usingBlock:block];
}

- (NSInteger)pk_lastIndex {
    if (!self.count) return 0;
    return self.count - 1;
}

- (id)pk_objAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (id)pk_firstObjAtRange:(NSRange)range {
    if (range.location < self.count) return self[range.location];
    return nil;
}

- (id)pk_lastObjAtRange:(NSRange)range {
    NSUInteger lastIndex = NSMaxRange(range) - 1;
    if (lastIndex < self.count) return self[lastIndex];
    return nil;
}

- (CGPeakValue)pk_peakValueBySel:(SEL)sel {
    if (!self.count) return CGPeakValueZero;
    IMP imp = [self.lastObject methodForSelector:sel];
    CGFloat(*msgSend)(id, SEL) = (void*)imp;
    CGPeakValue peakValue = CGPeakValueMake(msgSend(self[0], sel), msgSend(self[0], sel));
    for (id obj in self) {
        CGFloat tempValue = msgSend(obj, sel);
        if (tempValue > peakValue.max) peakValue.max = tempValue;
        if (tempValue < peakValue.min) peakValue.min = tempValue;
    }
    return peakValue;
}

- (CGPeakValue)pk_peakValueAtRange:(NSRange)range bySel:(SEL)sel {
    if (!self.count) return CGPeakValueZero;
    IMP imp = [self.lastObject methodForSelector:sel];
    CGFloat(*msgSend)(id, SEL) = (void*)imp;
    CGFloat firstValue = msgSend(self[range.location], sel);
    __block CGPeakValue peakValue = CGPeakValueMake(firstValue, firstValue);
    [self pk_enumerateObjsAtRange:range ceaselessBlock:^(id  _Nonnull obj, NSUInteger idx) {
        CGFloat tempValue = msgSend(obj, sel);
        if (tempValue > peakValue.max) peakValue.max = tempValue;
        if (tempValue < peakValue.min) peakValue.min = tempValue;
    }];
    return peakValue;
}

- (CGPeakValue)pk_peakValueWithEvaluatedBlock:(CGFloat (NS_NOESCAPE^)(id _Nonnull))block {
    if (!self.count) return CGPeakValueZero;
    CGPeakValue peakValue = CGPeakValueMake(block(self[0]), block(self[0]));
    for (id obj in self) {
        CGFloat tempValue = block(obj);
        if (tempValue > peakValue.max) peakValue.max = tempValue;
        if (tempValue < peakValue.min) peakValue.min = tempValue;
    }
    return peakValue;
}

- (CGPeakValue)pk_peakValueSkipZeroWithEvaluatedBlock:(CGFloat (^NS_NOESCAPE)(id _Nonnull))block {
    if (!self.count) return CGPeakValueZero;
    CGPeakValue peakValue = CGPeakValueMake(block(self[0]), block(self[0]));
    for (id obj in self) {
        CGFloat tempValue = block(obj);
        if (CGFloatEqualZero(tempValue)) continue;
        if (tempValue > peakValue.max) peakValue.max = tempValue;
        if (tempValue < peakValue.min) peakValue.min = tempValue;
    }
    return peakValue;
}

- (CGPeakValue)pk_peakValueAtRange:(NSRange)range evaluatedBlock:(CGFloat (^NS_NOESCAPE)(id _Nonnull))block {
    if (!self.count) return CGPeakValueZero;
    __block CGPeakValue peakValue = CGPeakValueMake(block(self[range.location]), block(self[range.location]));
    NSInteger length = NSMaxRange(range);
    for (NSInteger idx = range.location; idx < length; idx++) {
        CGFloat tempValue = block(self[idx]);
        if (tempValue > peakValue.max) peakValue.max = tempValue;
        if (tempValue < peakValue.min) peakValue.min = tempValue;
    }
    return peakValue;
}

- (CGPeakValue)pk_peakValueSkipZeroAtRange:(NSRange)range evaluatedBlock:(CGFloat (^NS_NOESCAPE)(id _Nonnull))block {
    __block CGPeakValue peakValue = CGPeakValueMake(block(self[range.location]), block(self[range.location]));
    NSInteger length = NSMaxRange(range);
    for (NSInteger idx = range.location; idx < length; idx++) {
        CGFloat tempValue = block(self[idx]);
        if (CGFloatEqualZero(tempValue)) continue;
        if (tempValue > peakValue.max) peakValue.max = tempValue;
        if (tempValue < peakValue.min) peakValue.min = tempValue;
    }
    return peakValue;
}

- (CGFloat)pk_spanValueWithReferenceValue:(CGFloat)referenceValue evaluatedBlock:(CGFloat (^NS_NOESCAPE)(id _Nonnull))block {
    CGPeakValue peakValue = [self pk_peakValueSkipZeroWithEvaluatedBlock:block];
    if (CGPeakValueContainZero(peakValue)) return 0;
    CGFloat value1 = fabs(peakValue.max - referenceValue);
    CGFloat value2 = fabs(peakValue.min - referenceValue);
    CGFloat maxValue = MAX(value1, value2);
    return fmax(maxValue, 0);
}

@end

@implementation NSArray (PKStockChartParagraphed)

+ (NSArray<NSString *> *)pk_arrayWithParagraphs:(NSInteger)paragraphs peakValue:(CGPeakValue)peakValue {
    paragraphs = paragraphs > 0 ? paragraphs : 1;
    NSMutableArray<NSString *> *texts = [NSMutableArray array];
    CGFloat segments = fabs(peakValue.max - peakValue.min) / (CGFloat)paragraphs;
    for (NSInteger i = 0; i <= paragraphs; i++) {
        NSString *aString = [NSString stringWithFormat:@"%.2f", peakValue.max - segments * i];
        [texts addObject:aString];
    }
    return texts.copy;
}

+ (NSArray<NSString *> *)pk_arrayWithParagraphs:(NSInteger)paragraphs peakValue:(CGPeakValue)peakValue resultBlock:(NSString * _Nonnull (NS_NOESCAPE ^)(CGFloat, NSUInteger))block {
    paragraphs = paragraphs > 0 ? paragraphs : 1;
    NSMutableArray<NSString *> *texts = [NSMutableArray array];
    CGFloat segments = fabs(peakValue.max - peakValue.min) / (CGFloat)paragraphs;
    for (NSInteger i = 0; i <= paragraphs; i++) {
        CGFloat floatValue = peakValue.max - (CGFloat)segments * i;
        NSString *aString = block(floatValue, i);
        [texts addObject:aString];
    }
    return texts.copy;
}

@end
