//
//  PKIndicatorLayerProtocol.h
//  PKChartKit
//
//  Created by zhanghao on 2017/12/15.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSValue+PKGeometry.h"
@class PKChartTextRenderer;

NS_ASSUME_NONNULL_BEGIN

/** 实现该协议的指标layer，图表将绘制在主图区域 */
@protocol PKIndicatorMajorProtocol <NSObject>

@required

/** 绘制当前范围主图区域指标 */
- (void)drawMajorChartInRange:(NSRange)range;

/** 返回当前范围主图区域的极值，用于自定义主图区域的最大最小值 */
- (CGPeakValue)majorChartPeakValue:(CGPeakValue)peakValue forRange:(NSRange)range;

@optional

/** 返回数组内每个索引所对应的信息 */
- (nullable NSAttributedString *)majorChartAttributedTextForIndex:(NSInteger)index;

/** 返回数组内当前范围所对应的信息 */
- (nullable NSAttributedString *)majorChartAttributedTextForRange:(NSRange)range;

@end

/** 实现该协议的指标layer，图表将绘制在副图区域 */
@protocol PKIndicatorMinorProtocol <NSObject>

@required

/** 绘制当前范围副图区域指标 */
- (void)drawMinorChartInRange:(NSRange)range;

/** 返回当前范围副图区域的极值，用于自定义副图区域的最大最小值 */
- (CGPeakValue)minorChartPeakValueForRange:(NSRange)range;

/** 返回文本渲染数组并更新网络路径，用于自定义当前副图区域网格线和文本内容 */
- (nullable NSArray<PKChartTextRenderer *> *)minorChartTrellisForPeakValue:(CGPeakValue)peakValue path:(UIBezierPath * _Nonnull __autoreleasing *_Nonnull)pathPointer;

@optional

/** 返回数组内每个索引所对应的信息 */
- (nullable NSAttributedString *)minorChartAttributedTextForIndex:(NSInteger)index;

/** 返回数组内当前范围所对应的信息 */
- (nullable NSAttributedString *)minorChartAttributedTextForRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
