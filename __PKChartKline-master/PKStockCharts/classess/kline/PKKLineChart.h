//
//  PKKLineChart.h
//  PKChartKit
//
//  Created by zhanghao on 2017/12/6.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKKLineBaseChart.h"
#import "PKKLineChartProtocol.h"
#import "PKKLineChartSet.h"
#import "PKIndicatorChartSet.h"
#import "PKIndicatorIdentifier.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PKKLineChartDelegate;

@interface PKKLineChart : PKKLineBaseChart

@property (nonatomic, weak, nullable) id<PKKLineChartDelegate> delegate;

/** 设置图表样式 */
@property (nonatomic, strong) PKKLineChartSet *set;

/** 设置指标样式 */
@property (nonatomic, strong) PKIndicatorChartSet *indicatorSet;

/** 自定义时间线间隔 */
@property (nonatomic, copy) NSIndexSet* (^makeTimelineIndexSets)(PKKLineChartPeriod period, NSRange atRange);

/** 自定义时间线日期文本 */
@property (nonatomic, copy) NSString* (^makeDateTextCallback)(id<PKKLineChartProtocol> obj, BOOL isPressed);

/** 数据源走势列表 */
@property (nonatomic, copy) NSArray<id<PKKLineChartProtocol>> *dataList;

/** 插入更多数据走势列表，自动校准视图偏移位置 */
- (void)insertDataList:(NSArray<id<PKKLineChartProtocol>> *)dataList;
 
/**
 * 注册指标class并设置对应的identifier(所有指标使用前必须先注册)
 *
 * class 类必须为PKIndicatorBaseLayer的子类
 * class 类必须实现PKIndicatorMajorProtocol或PKIndicatorMinorProtocol(二选一)
 *
 * identifier 指标类型对应的唯一标识符
 */
- (void)registerClass:(Class)aClass forIndicatorIdentifier:(PKIndicatorIdentifier)identifier;

/** 设置主图区域默认显示的指标 */
@property (nonatomic, strong, nullable) NSString *defaultMajorIndicatorIdentifier;

/** 设置副图区域默认显示的指标 */
@property (nonatomic, strong, nullable) NSString *defaultMinorIndicatorIdentifier;

/** 主图区域当前显示的指标 */
@property (nonatomic, strong, readonly, nullable) NSString *currentMajorIndicatorIdentifier;

/** 副图区域当前显示的指标 */
@property (nonatomic, strong, readonly, nullable) NSString *currentMinorIndicatorIdentifier;

/** 根据identifier切换相应的指标 */
- (void)changeIndicatorWithIdentifier:(NSString *)identifier;

/** 根据identifier清除相应的指标 */
- (void)clearIndicatorWithIdentifier:(NSString *)identifier;

/** 绘制图表 */
- (void)drawChart;

/** 清空图表 */
- (void)clearChart;

@end


@protocol PKKLineChartDelegate <NSObject>
@optional

/** 图表单击时回调 */
- (void)klineChart:(PKKLineChart *)klineChart didSingleTapAtRegionType:(PKChartRegionType)type;

/** 图表双击时回调 */
- (void)klineChart:(PKKLineChart *)klineChart didDoubleTapAtRegionType:(PKChartRegionType)type;

/** 图表将要长按时回调 */
- (void)klineChartWillLongPress:(PKKLineChart *)klineChart;

/** 图表正在长按中 (index为当前点对应在数组中的索引) */
- (void)klineChart:(PKKLineChart *)klineChart didLongPressAtCorrespondIndex:(NSInteger)index;

/** 图表长按结束时回调 */
- (void)klineChartEndLongPress:(PKKLineChart *)klineChart;

/** 图表将要捏合时回调 */
- (void)klineChartWillPinch:(PKKLineChart *)klineChart;

/** 图表正在捏合中 (index为可视范围内最新点对应的索引) */
- (void)klineChart:(PKKLineChart *)klineChart didPinchAtVisibleLatestIndex:(NSInteger)index;

/** 图表捏合结束时回调 */
- (void)klineChartEndPinch:(PKKLineChart *)klineChart;

/** 图表十字线消失时回调 */
- (void)klineChartCrossLineDidDismiss:(PKKLineChart *)klineChart;

/** 图表十字线纵轴提示文本点击回调 (index为当前点对应在数组中的索引) */
- (void)klineChart:(PKKLineChart *)klineChart didTapTipAtCorrespondIndex:(NSInteger)index;

/** 图表显示加载更多时回调 */
- (void)klineChartDidBeginPullLoading:(PKKLineChart *)klineChart;

@end


@interface PKKLineChart (SlideOperation)

/** 能否向左滑动一次 */
@property (nonatomic, assign, readonly) BOOL canSlideToLeftOnce;

/** 能否向右滑动一次 */
@property (nonatomic, assign, readonly) BOOL canSlideToRightOnce;

/** 向左滑动一次 */
- (void)slideToLeftOnce;

/** 向右滑动一次 */
- (void)slideToRightOnce;

@end


@interface PKKLineChart (ScaleOperation)

/** 能否缩小一次 */
@property (nonatomic, assign, readonly) BOOL canSmallOnce;

/** 能否放大一次 */
@property (nonatomic, assign, readonly) BOOL canLargeOnce;

/** 缩小一次(以中心位置缩小) */
- (void)doSmallScaleOnce;

/** 放大一次(以中心位置放大) */
- (void)doLargeScaleOnce;

@end


@interface PKKLineChart (LoadingOperation)

/** 结束更多加载 */
- (void)endPullLoading;

@end

NS_ASSUME_NONNULL_END
