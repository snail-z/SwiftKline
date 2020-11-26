//
//  NSArray+PKStockChart.h
//  PKChartKit
//
//  Created by zhanghao on 2017/11/28.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSValue+PKGeometry.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (PKStockChart)

/** 遍历数组内所有下标 */
- (void)pk_enumerateIndexsCeaselessBlock:(void (NS_NOESCAPE ^)(NSUInteger idx))block;

/** 遍历数组内所有元素 */
- (void)pk_enumerateObjsCeaselessBlock:(void (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx))block;

/** 遍历数组某范围内元素 */
- (void)pk_enumerateObjsAtRange:(NSRange)range
                 ceaselessBlock:(void (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx))block;

/** 遍历数组某范围内元素(*stop停止遍历) */
- (void)pk_enumerateObjsAtRange:(NSRange)range
                     usingBlock:(void (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))block;

/** 数组末尾元素下标 */
- (NSInteger)pk_lastIndex;

/** 获取index对应的元素避免越界 */
- (nullable ObjectType)pk_objAtIndex:(NSUInteger)index;

/** 获取range范围内的首元素 */
- (nullable ObjectType)pk_firstObjAtRange:(NSRange)range;

/** 获取range范围内的末尾元素 */
- (nullable ObjectType)pk_lastObjAtRange:(NSRange)range;

/** 根据对象sel方法，查找数组内的最大最小值 */
- (CGPeakValue)pk_peakValueBySel:(SEL)sel;

/** 根据对象sel方法，查找数组某范围内最大最小值 */
- (CGPeakValue)pk_peakValueAtRange:(NSRange)range bySel:(SEL)sel;

/** 根据evaluatedBlock返回值，查找数组内最大最小值 */
- (CGPeakValue)pk_peakValueWithEvaluatedBlock:(CGFloat (NS_NOESCAPE ^)(ObjectType evaluatedObject))block;

/** 根据evaluatedBlock返回值，查找数组内最大最小值(跳过零值) */
- (CGPeakValue)pk_peakValueSkipZeroWithEvaluatedBlock:(CGFloat (NS_NOESCAPE ^)(ObjectType evaluatedObject))block;

/** 根据evaluatedBlock返回值，查找数组某范围内最大最小值 */
- (CGPeakValue)pk_peakValueAtRange:(NSRange)range
                    evaluatedBlock:(CGFloat (NS_NOESCAPE ^)(ObjectType evaluatedObject))block;

/** 根据evaluatedBlock返回值，查找数组某范围内最大最小值(跳过零值) */
- (CGPeakValue)pk_peakValueSkipZeroAtRange:(NSRange)range
                            evaluatedBlock:(CGFloat (NS_NOESCAPE ^)(ObjectType evaluatedObject))block;

/** 计算数组内极值与参考值的最大跨度 */
- (CGFloat)pk_spanValueWithReferenceValue:(CGFloat)referenceValue
                           evaluatedBlock:(CGFloat (NS_NOESCAPE ^)(ObjectType evaluatedObject))block;

@end

@interface NSArray<ObjectType> (PKStockChartParagraphed)

/** 将peakValue值分段后重组成数组，保留两位小数(返回的新数组个数为paragraphs+1个)  */
+ (NSArray<NSString *> *)pk_arrayWithParagraphs:(NSInteger)paragraphs
                                      peakValue:(CGPeakValue)peakValue;

/** 同上方法，支持resultBlock外部自定义文本 */
+ (NSArray<NSString *> *)pk_arrayWithParagraphs:(NSInteger)paragraphs
                                      peakValue:(CGPeakValue)peakValue
                                    resultBlock:(NSString *(NS_NOESCAPE ^)(CGFloat floatValue, NSUInteger index))block;

@end

NS_ASSUME_NONNULL_END
