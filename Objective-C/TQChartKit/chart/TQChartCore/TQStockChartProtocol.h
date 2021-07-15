//
//  TQStockChartProtocol.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

// 绘制分时图需要的相关协议
@protocol TQTimeChartPropProtocol <NSObject>
@optional

/** 昨日收盘 (用于连接第一个点) */
- (CGFloat)tq_originPrice;

/** 右边y轴最大涨幅值 */
- (CGFloat)tq_maxChangeRatio;

/** 右边y轴最小涨幅值 */
- (CGFloat)tq_minChangeRatio;

/** 左边y轴最大值 */
- (CGFloat)tq_maxPrice;

/** 左边y轴最小值 */
- (CGFloat)tq_minPrice;

/** 成交量区域坐标轴最高值 */
- (CGFloat)tq_maxVolume;

/** 成交量区域坐标轴最小值 */
- (CGFloat)tq_minVolume;

@end


@protocol TQTimeChartProtocol <NSObject>
@required

/** 分时价 */
- (CGFloat)tq_timePrice;

/** 分时图均价 */
- (CGFloat)tq_timeAveragePrice;

/** 分时图涨跌比率(昨收) */
- (CGFloat)tq_timeClosePrice; //TODO 不需要

/** 成交量 */
- (CGFloat)tq_timeVolume;

/** 分时详细时间 */
- (NSDate *)tq_timeDate;

@end


// 绘制K线图相关协议
@protocol TQKlineChartProtocol <NSObject>
@required

/** 开盘价 */
- (CGFloat)tq_open;

/** 收盘价 */
- (CGFloat)tq_close;

/** 最高价 */
- (CGFloat)tq_high;

/** 最低价 */
- (CGFloat)tq_low;

/** 成交量 */
- (CGFloat)tq_volume;

/** K线详细日期 */
- (NSDate *)tq_date;

@optional

/** 昨日收盘价 */
- (CGFloat)tq_closeYesterday;

@end
