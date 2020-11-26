//
//  PKTimeChartProtocol.h
//  PKChartKit
//
//  Created by zhanghao on 2017/11/28.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSValue+PKGeometry.h"
#import "PKChartConst.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PKTimeChartProtocol <NSObject>

@required

/** 最新价 */
- (CGFloat)pk_latestPrice;

/** 均价 */
- (CGFloat)pk_averagePrice;

/** 成交量 */
- (CGFloat)pk_volume;

/** 日期时间 */
- (NSDate *)pk_dateTime;

@optional

/** 大盘红绿柱 */
- (CGFloat)pk_leadRGBarVolume;

/** 大盘红绿柱方向 (上涨返回YES，下跌返回NO) */
- (BOOL)pk_isLeadRGBarUpward;

@end


@protocol PKTimeChartCoordProtocol <NSObject>

@optional

/** 坐标轴最大值 */
- (CGFloat)pk_maxPrice;

/** 坐标轴最小值 */
- (CGFloat)pk_minPrice;

/** 最大涨幅值 */
- (CGFloat)pk_maxChangeRate;

/** 最小涨幅值 */
- (CGFloat)pk_minChangeRate;

/** 最高成交量 */
- (CGFloat)pk_maxVolume;

/** 最低成交量 */
- (CGFloat)pk_minVolume;

/** 昨收价 */
- (CGFloat)pk_referenceValue;

@end


@protocol PKTimeChartPileProtocol <NSObject>

@required

/** 返回叠加图表所在的区域 */
- (PKChartRegionType)pileChartRegionType;

/** 绘制叠加图表 */
- (void)pileChart;

/** 返回对应区域包括叠加图表的极值 */
- (CGPeakValue)pileChartPeakValue:(CGPeakValue)peakValue;

@end

NS_ASSUME_NONNULL_END
