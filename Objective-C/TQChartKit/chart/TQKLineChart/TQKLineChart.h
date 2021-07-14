//
//  TQKLineChart.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/26.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQKLineBaseChart.h"
#import "TQKLineChartStyle.h"
#import "TQStockChartLayout.h"
#import "TQIndicatorBaseLayer.h"
#import "TQKIndicatorBaseLayer.h"
#import "TQKLineLoadingView.h"
#import "TQChartCrossLineView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TQKLineChartDelegate;
@interface TQKLineChart : TQKLineBaseChart

@property (nonatomic, weak) id<TQKLineChartDelegate> delegate;

/** 加载更多视图 */
@property (nonatomic, strong, readonly) TQKLineLoadingView *loadingView;

/** 设置图表内部布局 */
@property (nonatomic, strong) TQStockChartLayout *layout;

/** 设置K线外观样式 */
@property (nonatomic, strong) TQKLineChartStyle *style;

/** 设置指标外观样式 */
@property (nonatomic, strong) TQIndicatorChartStyle *indicatorStyles;

/** 设置数据源 */
@property (nonatomic, strong) NSArray<id<TQKlineChartProtocol>> *dataArray;

/** 加载更多数据后，通过该方法设置数据源 */
- (void)insertEarlierDataArray:(NSArray<id<TQKlineChartProtocol>> *)earlierData;

/** 当前显示的指标的identifier */
@property (nonatomic, copy, readonly) NSString *indicatorIdentifier;

/** 注册指标class并设置对应的identifier */
- (void)registerClass:(Class)aClass forIndicatorIdentifier:(NSString *)identifier;

/** 根据指标的identifier切换指标 */
- (void)changeIndicatorWithIdentifier:(NSString *)identifier;

/** 更新图表 */
- (void)drawChart;

//- (void)doTimelinesSeparated;

@end

@protocol TQKLineChartDelegate <NSObject>
@optional

/** 图表单击时回调 */
- (void)stockKLineChart:(TQKLineChart *)KLineChart didSingleTapInLocation:(CGPoint)location;

/** 图表双击时回调 */
- (void)stockKLineChart:(TQKLineChart *)KLineChart didDoubleTapInLocation:(CGPoint)location;

/** 图表将要长按时回调 */
- (void)stockKLineChartWillLongPress:(TQKLineChart *)KLineChart;

/** 图表长按时回调 */
- (void)stockKLineChart:(TQKLineChart *)KLineChart didLongPressAtCorrespondIndex:(NSInteger)index;

/** 图表长按结束时回调 */
- (void)stockKLineChartEndLongPress:(TQKLineChart *)KLineChart;

@end

NS_ASSUME_NONNULL_END
