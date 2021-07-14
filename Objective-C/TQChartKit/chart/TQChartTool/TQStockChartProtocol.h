//
//  TQStockChartProtocol.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - TQTimeChartPropProtocol

// (分时图协议)该协议主要用于控制坐标系统相关的绘制操作
@protocol TQTimeChartCoordsProtocol <NSObject>
@optional

/** 昨日收盘 (用于连接第一个点) */
- (CGFloat)tq_originPrice;

/** 分时线区域坐标轴最大值 */
- (CGFloat)tq_maxPrice;

/** 分时线区域坐标轴最小值 */
- (CGFloat)tq_minPrice;

/** 分时线区域最大涨幅值 */
- (CGFloat)tq_maxChangeRatio;

/** 分时线区域最小涨幅值 */
- (CGFloat)tq_minChangeRatio;

/** 成交量区域坐标轴最高值 */
- (CGFloat)tq_maxVolume;

/** 成交量区域坐标轴最小值 */
- (CGFloat)tq_minVolume;

@end

#pragma mark - TQTimeChartProtocol

// (分时图协议)该协议主要用于控制图表相关的绘制操作
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

#pragma mark - TQKlineChartProtocol

// (K线图协议)该协议主要用于控制K线图表相关的绘制操作
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

/** 成交额 */
- (CGFloat)tq_turnover;

/** 昨日收盘价 */
- (CGFloat)tq_closeYesterday;

/** K线详细日期 */
- (NSDate *)tq_date;

@end

NS_ASSUME_NONNULL_END
