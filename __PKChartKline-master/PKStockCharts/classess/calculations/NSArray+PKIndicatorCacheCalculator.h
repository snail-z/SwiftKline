//
//  NSArray+PKIndicatorCacheCalculator.h
//  PKChartKit
//
//  Created by zhanghao on 2017/12/26.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (PKIndicatorCacheCalculator)

/* 计算某范围length周期内的移动平均值(小于该周期的maValue不计算默认为0值) */
- (void)pk_enumerateMAValue:(NSUInteger)length
                      range:(NSRange)range
             evaluatedBlock:(CGFloat (^NS_NOESCAPE)(ObjectType evaluatedObject))block
                 usingBlock:(void (NS_NOESCAPE ^)(NSUInteger idx, CGFloat MAValue))callback;

/** 从某个位置起向前计算length周期内evaluatedBlock返回值的和 */
- (CGFloat)pk_sumValueStart:(NSUInteger)idx
                     length:(NSUInteger)length
             evaluatedBlock:(CGFloat (NS_NOESCAPE ^)(ObjectType evaluatedObject))block;

/** 从某个位置起向前计算length周期内conditionBlock条件成立的总次数 */
- (NSUInteger)pk_timesValueStart:(NSUInteger)idx
                          length:(NSUInteger)length
                  conditionBlock:(BOOL (^NS_NOESCAPE)(ObjectType object))block;

/** 从某个位置起向前计算length周期内的标准差(或样本标准差) ssd -> sample standard deviation */
- (CGFloat)pk_ssdValueStart:(NSUInteger)idx
                     length:(NSUInteger)length
                        avg:(CGFloat)avgValue
             evaluatedBlock:(CGFloat (NS_NOESCAPE ^)(ObjectType evaluatedObject))block;

@end

NS_ASSUME_NONNULL_END
