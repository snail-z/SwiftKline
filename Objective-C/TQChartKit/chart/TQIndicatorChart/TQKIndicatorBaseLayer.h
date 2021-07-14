//
//  TQIndicatorKBaseLayer.h
//  TQChartKit
//
//  Created by zhanghao on 2018/9/14.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorParentLayer.h"

NS_ASSUME_NONNULL_BEGIN

///继承自该类的指标，将绘制在K线区域///
@interface TQKIndicatorBaseLayer : TQIndicatorParentLayer

/** 子类实现该方法，用于自定义K线区域的最大最小值 */
- (CGPeakValue)KIndicatorPeakValue:(CGPeakValue)peakValue forRange:(NSRange)range;

/** 子类实现该方法，用于显示当前index对应的文本内容等 */
- (nullable NSAttributedString *)KIndicatorAttributedTextForIndex:(NSInteger)index;

/** 子类实现该方法，用于显示当前range对应的文本内容等 */
- (nullable NSAttributedString *)KIndicatorAttributedTextForRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
