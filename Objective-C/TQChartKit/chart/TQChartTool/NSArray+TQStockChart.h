//
//  NSArray+TQStockChart.h
//  TQChartKit
//
//  Created by zhanghao on 2018/8/29.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TQStockChartUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (TQStockChart)

/** 遍历数组某范围内元素 */
- (void)enumerateObjsAtRange:(NSRange)range
              ceaselessBlock:(void (^)(ObjectType obj, NSUInteger idx))block;

/** 遍历数组某范围内元素(可停止遍历) */
- (void)enumerateObjsAtRange:(NSRange)range
                  usingBlock:(void (^)(ObjectType obj, NSUInteger idx, BOOL *stop))block;

/** 获取range范围内的首元素 */
- (nullable ObjectType)firstObjInRange:(NSRange)range;

/** 获取range范围内的末尾元素 */
- (nullable ObjectType)lastObjInRange:(NSRange)range;

/** 数组末尾元素下标 */
- (NSInteger)lastIdx;

/** 数组中间元素下标(数组元素有奇数个时准确唯一) */
- (NSInteger)middleIdx;

/** 根据对象sel方法，查找数组内的最大最小值 */
- (CGPeakValue)peakValueBySel:(SEL)sel;

/** 根据对象sel方法，查找数组某范围内最大最小值 */
- (CGPeakValue)peakValueWithRange:(NSRange)range bySel:(SEL)sel;

/** 根据evaluatedBlock返回值，查找数组内最大最小值 */
- (CGPeakValue)peakValueWithEvaluatedBlock:(CGFloat (NS_NOESCAPE ^)(ObjectType evaluatedObject))block;

/** 根据evaluatedBlock返回值，查找数组某范围内最大最小值 */
- (CGPeakValue)peakValueWithRange:(NSRange)range
                   evaluatedBlock:(CGFloat (NS_NOESCAPE ^)(ObjectType evaluatedObject))block;

- (CGPeakValue)peakValueWithRange:(NSRange)range
                  evaluatedBlocks:(NSArray* (NS_NOESCAPE ^)(ObjectType evaluatedObjects))block;

/** 根据evaluatedBlock返回值，查找数组某范围内最大最小值(跳过零值) */
- (CGPeakValue)peakValueSkipZeroWithRange:(NSRange)range
                           evaluatedBlock:(CGFloat (NS_NOESCAPE ^)(ObjectType evaluatedObject))block;

/** 根据evaluatedBlock返回值，查找数组某范围内最大最小值及对应下标 */
- (CGPeakIndexValue)peakIndexValueWithRange:(NSRange)range
                             evaluatedBlock:(CGFloat (NS_NOESCAPE ^)(ObjectType evaluatedObject))block;

/** 从idx位置起向前计算length周期内evaluatedBlock返回值的和 */
- (CGFloat)sumCalculation:(NSUInteger)idx length:(NSUInteger)length
           evaluatedBlock:(CGFloat (NS_NOESCAPE ^)(ObjectType evaluatedObject))block;

/** 从idx位置起向前计算length周期内evaluatedBlock返回值的积 */
- (CGFloat)productCalculation:(NSUInteger)idx length:(NSUInteger)length
               evaluatedBlock:(CGFloat (NS_NOESCAPE ^)(ObjectType evaluatedObject))block;

/** 从idx位置起向前计算length周期内conditionBlock条件成立的总次数 */
- (NSUInteger)timesCalculation:(NSUInteger)idx length:(NSUInteger)length
                conditionBlock:(BOOL (^NS_NOESCAPE)(ObjectType object))block;

/** 从idx位置起向前计算length周期内的标准差(或样本标准差) ssd -> sample standard deviation */
- (CGFloat)ssdCalculation:(NSUInteger)idx length:(NSUInteger)length avg:(CGFloat)avgValue
            evaluatedBlock:(CGFloat (NS_NOESCAPE ^)(ObjectType evaluatedObject))block;

/* 从idx位置起向前计算length周期内的移动平均值(小于该周期的maValue不计算默认为0) */
- (void)enumerateCalculateMA:(NSUInteger)length range:(NSRange)range
              evaluatedBlock:(CGFloat (^NS_NOESCAPE)(ObjectType evaluatedObject))block
                  usingBlock:(void (NS_NOESCAPE ^)(NSUInteger idx, CGFloat maValue))resultBlock;

@end

@interface NSArray<ObjectType> (TQStockChartStatic)

/** 根据peak值分割后构建新数组(返回的新数组元素个数为partitions+1个)保留两位小数 */
+ (NSArray<NSString *> *)arrayWithPartition:(NSInteger)partitions peakValue:(CGPeakValue)peakValue;

/** 根据peak值分割后构建新数组，增加resultBlock外部自定义操作 */
+ (NSArray<NSString *> *)arrayWithPartition:(NSInteger)partitions peakValue:(CGPeakValue)peakValue
                                resultBlock:(NSString *(NS_NOESCAPE ^)(CGFloat floatValue, NSUInteger idx))block;

@end

NS_ASSUME_NONNULL_END
