//
//  TQIndicatorBaseLayer.h
//  TQChartKit
//
//  Created by zhanghao on 2018/8/2.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorParentLayer.h"
#import "TQChartTextLayer.h"

NS_ASSUME_NONNULL_BEGIN

///继承自该类的指标，将绘制在底部指标区域///
@interface TQIndicatorBaseLayer : TQIndicatorParentLayer

/** 子类实现该方法，用于自定义当前指标范围内的最大最小值 */
- (CGPeakValue)indicatorPeakValueForRange:(NSRange)range;

/** 子类实现该方法，用于自定义当前指标的网格线文本内容等 */
- (nullable NSArray<TQChartTextRenderer *> *)indicatorTrellisForPeakValue:(CGPeakValue)peakValue path:(UIBezierPath *__autoreleasing *)pathPointer;

/** 子类实现该方法，用于显示当前index对应的文本内容等 */
- (nullable NSAttributedString *)indicatorAttributedTextForIndex:(NSInteger)index;

/** 子类实现该方法，用于显示当前range内对应的文本内容等 */
- (nullable NSAttributedString *)indicatorAttributedTextForRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
