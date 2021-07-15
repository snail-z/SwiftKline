//
//  TQTimeChart.h
//  CoreGraphics_demo
//
//  Created by zhanghao on 2018/7/6.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import "TQTimeBaseChart.h"
#import "TQTimeChartConfiguration.h"
#import "TQStockChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TQTimeChartDelegate;
@interface TQTimeChart : TQTimeBaseChart

@property (nonatomic, assign, readonly) CGRect chartFrame;
@property (nonatomic, assign, readonly) CGRect chartTimeFrame;
@property (nonatomic, assign, readonly) CGRect chartVolumeFrame;
@property (nonatomic, assign, readonly) CGRect chartRiverFrame;
@property (nonatomic, weak) id<TQTimeChartDelegate> delegate;

/** 设置外观样式 */
@property (nonatomic, strong) TQTimeChartConfiguration *configuration;

/** 用于控制绘制分时图坐标值 */
@property (nonatomic, strong) id<TQTimeChartPropProtocol> propData;

/** 设置数据源 */
@property (nonatomic, strong) NSArray<id<TQTimeChartProtocol>> *dataArray;

/** 设置时间线文本数据 */
@property (nonatomic, strong) NSArray<NSString *> *dateTimeArray;

/** 设置内边距(边缘留白) */
@property (nonatomic, assign) UIEdgeInsets contentEdgeInset;

/** 设置分时图表高度 */
@property (nonatomic, assign) CGFloat chartTimeHeight;

/** 设置中间分隔区域 */
@property (nonatomic, assign) CGFloat chartSeparationGap;

/** 绘制图表 */
- (void)drawChart;

@end

@protocol TQTimeChartDelegate <NSObject>
@optional

/** 图表长按时回调 */
- (void)stockTimeChart:(TQTimeChart *)timeChart didLongPresOfIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
