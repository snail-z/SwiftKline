//
//  TQStockChart+Categories.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TQStockChartUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (TQStockChart)

/** 遍历数组某范围内元素 */
- (void)tq_enumerateObjectsAtRange:(NSRange)range
                        usingBlock:(void (^)(ObjectType obj, NSUInteger idx, BOOL *stop))block;

/** 获取range范围内的首元素 */
- (nullable ObjectType)tq_firstObjectAtRange:(NSRange)range;

/** 获取range范围内的末尾元素 */
- (nullable ObjectType)tq_lastObjectAtRange:(NSRange)range;

/** 数组末尾元素下标 */
- (NSInteger)tq_lastIndex;

/** 数组中间元素下标(当数组个数为奇数个时有效) */
- (NSInteger)tq_middleIndex;

/** 根据对象sel方法，查找数组内的最大最小值 */
- (CGPeakValue)tq_peakValueBySel:(SEL)sel;

/** 根据对象sel方法，查找数组内某范围内的最大最小值 */
- (CGPeakValue)tq_peakValueWithRange:(NSRange)range bySel:(SEL)sel;

/** 根据最大和最小值等分后构建成新数组 (返回的新数组元素个数为 segments+1)
 - segments 等分数量段
 - format 格式化字符串 (e.g - %.2f %.f)
 - attachedText 附加字符串
 */
+ (NSArray<NSString *> *)tq_partitionWithPeak:(CGPeakValue)peak
                                     segments:(NSUInteger)segments
                                       format:(nullable NSString *)format
                                 attachedText:(nullable NSString *)attachedText;

/** 根据最大和最小值等分后构建成新数组 (返回的新数组元素个数为 segments+1)
 默认%.2f格式，保留两位小数
 */
+ (NSArray<NSString *> *)tq_partition2fWithPeak:(CGPeakValue)peak segments:(NSUInteger)segments;

@end

NS_ASSUME_NONNULL_END
