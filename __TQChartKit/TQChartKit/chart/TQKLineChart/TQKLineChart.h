//
//  TQKLineChart.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/26.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQKLineBaseChart.h"
#import "TQStockChartUtilities.h"
#import "TQKLineChartStyle.h"
#import "TQStockChartProtocol.h"
#import "TQIndexBaseLayer.h"
#import "TQKLineLoadingView.h"
#import "TQChartCrossLineView.h"
#import "TQStockChartLayout.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TQKLineChartDelegate;
@interface TQKLineChart : TQKLineBaseChart

@property (nonatomic, weak) id<TQKLineChartDelegate> delegate;

/** 加载更多视图 */
@property (nonatomic, strong, readonly) TQKLineLoadingView *loadingView;

/** 十字查价框视图 */
@property (nonatomic, strong, readonly) TQChartCrossLineView *crossLineView;

/** 设置图表内部布局 */
@property (nonatomic, strong) TQStockChartLayout *layout;

/** 设置K线外观样式 */
@property (nonatomic, strong) TQKLineChartStyle *style;

/** 设置指标外观样式 */
@property (nonatomic, strong) TQIndexChartStyle *style1;

/** 设置数据源 */
@property (nonatomic, strong) NSArray<id<TQKlineChartProtocol>> *dataArray;

/** 加载更多数据后，通过appendDataArray设置数据源 */
@property (nonatomic, strong) NSArray<id<TQKlineChartProtocol>> *appendDataArray;

- (void)drawChart;

@end

@protocol TQKLineChartDelegate <NSObject>
@optional

/** K线图表单击时回调 */
- (void)stockKLineChart:(TQKLineChart *)KLineChart didSingleTapInLocation:(CGPoint)location;

/** K线图表双击时回调 */
- (void)stockKLineChart:(TQKLineChart *)KLineChart didDoubleTapInLocation:(CGPoint)location;

/** K线图表长按时回调 */
- (void)stockKLineChart:(TQKLineChart *)KLineChart didLongPressAtCorrespondIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
