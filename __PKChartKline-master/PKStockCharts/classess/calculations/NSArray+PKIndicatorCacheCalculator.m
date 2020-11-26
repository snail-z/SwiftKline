//
//  NSArray+PKIndicatorCacheCalculator.m
//  PKChartKit
//
//  Created by zhanghao on 2017/12/26.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "NSArray+PKIndicatorCacheCalculator.h"
#import "NSArray+PKStockChart.h"
#import "NSValue+PKGeometry.h"

@implementation NSArray (PKIndicatorCacheCalculator)

- (void)pk_enumerateMAValue:(NSUInteger)length range:(NSRange)range evaluatedBlock:(CGFloat (^ NS_NOESCAPE)(id _Nonnull))block usingBlock:(void (^ NS_NOESCAPE)(NSUInteger, CGFloat))callback {
    __block CGFloat sum = 0.0;
    void (^calculated)(NSInteger) = ^(NSInteger start) {
        NSInteger max = NSMaxRange(range);
        for (NSInteger idx = start; idx < max; idx++) {
            CGFloat currentValue = block(self[idx]);
            sum += currentValue;
            CGFloat clearValue = block(self[idx - length]);
            sum -= clearValue;
            callback(idx, sum / length);
        }
    };
    
    if (range.location < length) {
        NSInteger endIndex = length - 1;
        for (NSInteger i = 0; i < endIndex; i++) {
            sum += block(self[i]);
            callback(i, 0);
        }
        sum += block(self[endIndex]);
        callback(endIndex, sum / length);
        calculated(length);
    } else {
        NSInteger endIndex = range.location - length;
        for (NSInteger i = range.location; i > endIndex; i--) {
            sum += block(self[i]);
        }
        callback(range.location, sum / length);
        calculated(range.location + 1);
    }
}

- (CGFloat)pk_sumValueStart:(NSUInteger)idx length:(NSUInteger)length evaluatedBlock:(CGFloat (^ NS_NOESCAPE)(id _Nonnull))block {
    NSRange range = idx < length ? NSMakeRange(0, idx + 1) : NSMakeRange(idx - length + 1, length);
    __block  CGFloat sum = 0;
    [self pk_enumerateObjsAtRange:range ceaselessBlock:^(id  _Nonnull obj, NSUInteger idx) {
        sum += block(obj);
    }];
    return sum;
}

- (NSUInteger)pk_timesValueStart:(NSUInteger)idx length:(NSUInteger)length conditionBlock:(BOOL (^ NS_NOESCAPE)(id _Nonnull))block {
    NSRange range = idx < length ? NSMakeRange(0, idx + 1) : NSMakeRange(idx - length + 1, length);
    __block  NSUInteger times = 0;
    [self pk_enumerateObjsAtRange:range ceaselessBlock:^(id  _Nonnull obj, NSUInteger idx) {
        if (block(obj)) times++;
    }];
    return times;
}

- (CGFloat)pk_ssdValueStart:(NSUInteger)idx length:(NSUInteger)length avg:(CGFloat)avgValue evaluatedBlock:(CGFloat (^ NS_NOESCAPE)(id _Nonnull))block {
    NSRange range = idx < length ? NSMakeRange(0, idx + 1) : NSMakeRange(idx - length + 1, length);
    __block CGFloat varianceValue = 0;
    [self pk_enumerateObjsAtRange:range ceaselessBlock:^(id  _Nonnull obj, NSUInteger idx) {
        CGFloat eachValue = block(obj);
        varianceValue += pow((eachValue - avgValue), 2);
    }];
    NSInteger sample = length < self.count ? (length - 1) : length;
    sample = CGValidDivisor(sample);
    return sqrt(varianceValue / (sample * 1.0));
}

@end
