//
//  TQStockTimePropData.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/23.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockTimePropData.h"
#import "TQStockChartUtilities.h"
#import "NSArray+TQStockChart.h"

@interface TQStockTimePropData ()

@property (nonatomic, assign) CGFloat priceOrigin;
@property (nonatomic, assign) CGPeakValue peakChangeRatio;
@property (nonatomic, assign) CGPeakValue peakPrice;
@property (nonatomic, assign) CGPeakValue peakVolume;

@end

@implementation TQStockTimePropData

/** 昨日收盘 (用于连接第一个点) */
- (CGFloat)tq_originPrice {
    return self.priceOrigin;
}

/** 右边y轴最大涨幅值 */
- (CGFloat)tq_maxChangeRatio {
    return self.peakChangeRatio.max;
}

/** 右边y轴最小涨幅值 */
- (CGFloat)tq_minChangeRatio {
    return self.peakChangeRatio.min;
}

/** 左边y轴最大值 */
- (CGFloat)tq_maxPrice {
    return self.peakPrice.max;
}

/** 左边y轴最小值 */
- (CGFloat)tq_minPrice {
    return self.peakPrice.min;
}

/** 成交量区域坐标轴最高值 */
- (CGFloat)tq_maxVolume {
    return self.peakVolume.max;
}

/** 成交量区域坐标轴最小值 */
- (CGFloat)tq_minVolume {
    return self.peakVolume.min;
}

- (void)defaultStyle {
    _priceOrigin = 5;
    _peakChangeRatio = CGPeakValueMake(2.57, -2.57);
    _peakPrice = CGPeakValueMake(17.94, 17.51);
}

- (void)fiveDayStyle {
    _priceOrigin = 18.9;
    _peakChangeRatio = CGPeakValueMake(3.57, -2.02);
    CGPeakValue peak = [self.dataArray peakValueBySel:@selector(tq_timePrice)];
    _peakPrice = peak;
}

@end
