//
//  TQKLineChart+Calculator.h
//  TQChartKit
//
//  Created by zhanghao on 2018/8/1.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQKLineChart.h"

@interface TQKLineChart (Calculator)

/** 获取应该绘制的K线范围 */
- (NSRange)getVisualRange;

/** 获取实际需要计算的的K线范围 */
- (NSRange)getCalculatedRange;

/** 获取range范围内绘制K线所需要的最大最小值及对应的下标 */
- (CGPeakIndexValue)getPeakIndexValueWithRange:(NSRange)range;

/** 获取range范围内绘制K线所需要的最大值最小值 */
- (CGPeakValue)getPeakValueWithRange:(NSRange)range;

/**  根据峰值点边缘间距，获取扩充peak值后的最大最小值 */
- (CGPeakValue)getEnlargePeakValue:(CGPeakValue)peak;

/** 根据index获取对应shape在根视图上的中心点 */
- (CGFloat)getCenterXInRootViewWithIndex:(NSInteger)index;

@end
