//
//  TQTimeChart.h
//  CoreGraphics_demo
//
//  Created by zhanghao on 2018/7/6.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import "TQTimeBaseChart.h"
#import "TQTimeChartStyle.h"
#import "TQStockChartLayout.h"
#import "TQStockChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TQTimeChartDelegate;
@interface TQTimeChart : TQTimeBaseChart

@property (nonatomic, weak) id<TQTimeChartDelegate> delegate;

/** 设置图表内部布局 */
@property (nonatomic, strong) TQStockChartLayout *layout;

/** 设置外观样式 */
@property (nonatomic, strong) TQTimeChartStyle *style;

/** 用于控制绘制分时图坐标值 */
@property (nonatomic, strong) id<TQTimeChartPropProtocol> propConfig;

/** 设置数据源 */
@property (nonatomic, strong) NSArray<id<TQTimeChartProtocol>> *dataArray;

/** 设置时间线文本数据(dateArray.count >= 2) */
@property (nonatomic, strong, nullable) NSArray<NSString *> *dateArray;

/** 绘制图表 */
- (void)drawChart;

@end

@protocol TQTimeChartDelegate <NSObject>
@optional

/** 分时图表单击时回调 */
- (void)stockTimeChart:(TQTimeChart *)timeChart didDoubleTapAtRange:(BOOL)isTimeChartRange;

/** 分时图表双击时回调 */
- (void)stockTimeChart:(TQTimeChart *)timeChart didSingleTapAtRange:(BOOL)isTimeChartRange;

/** 分时图表长按时回调 */
- (void)stockTimeChart:(TQTimeChart *)timeChart didLongPressAtCorrespondIndex:(NSInteger)index;

/** 分时图表长按结束时回调 */
- (void)stockTimeChartEndLongPress:(TQTimeChart *)timeChart;

@end

NS_ASSUME_NONNULL_END
