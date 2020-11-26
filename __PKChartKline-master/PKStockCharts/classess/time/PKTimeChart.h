//
//  PKTimeChart.h
//  PKChartKit
//
//  Created by zhanghao on 2017/11/27.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKTimeBaseChart.h"
#import "PKTimePileBaseLayer.h"
#import "PKTimeChartSet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PKTimeChartDelegate, PKTimeChartLegendDataSource;

@interface PKTimeChart : PKTimeBaseChart

@property (nonatomic, weak, nullable) id<PKTimeChartDelegate> delegate;
@property (nonatomic, weak, nullable) id<PKTimeChartLegendDataSource> legendSource;

/** 设置图表样式 */
@property (nonatomic, strong) PKTimeChartSet *set;

/** 自定义坐标系 */
@property (nonatomic, strong, nullable) NSObject<PKTimeChartCoordProtocol> *coordObj;

/** 数据源走势列表 */
@property (nonatomic, strong, nullable) NSArray<id<PKTimeChartProtocol>> *dataList;

/** 叠加自定义的图表 */
- (void)pileChartLayer:(__kindof PKTimePileBaseLayer<PKTimeChartPileProtocol> *)layer
         forIdentifier:(NSString *)identifier;

/** 删除指定的叠加图表 */
- (void)clearPileChartForIdentifier:(NSString *)identifier;

/** 删除所有叠加图表 */
- (void)clearPileChart;

/** 绘制图表 */
- (void)drawChart;

/** 清空图表 */
- (void)clearChart;

@end

@protocol PKTimeChartDelegate <NSObject>
@optional

/** 图表单击时回调 */
- (void)timeChart:(PKTimeChart *)timeChart didSingleTapAtRegionType:(PKChartRegionType)type;

/** 图表双击时回调 */
- (void)timeChart:(PKTimeChart *)timeChart didDoubleTapAtRegionType:(PKChartRegionType)type;

/** 图表将要长按时回调 */
- (void)timeChartWillLongPress:(PKTimeChart *)timeChart;

/** 图表正在长按中 (index为当前点对应在数组中的索引) */
- (void)timeChart:(PKTimeChart *)timeChart didLongPressAtCorrespondIndex:(NSInteger)index;

/** 图表长按结束时回调 */
- (void)timeChartEndLongPress:(PKTimeChart *)timeChart;

/** 图表十字线消失时回调 */
- (void)timeChartCrossLineDidDismiss:(PKTimeChart *)timeChart;

@end

@protocol PKTimeChartLegendDataSource <NSObject>
@optional

/** 返回主图区域的说明文本 */
- (nullable NSAttributedString *)timeChartMajorAttributedText;

/** 返回主图区域每个索引所对应的信息(长按中) */
- (nullable NSAttributedString *)timeChart:(PKTimeChart *)timeChart attributedTextForMajorAtIndex:(NSInteger)index;

/** 返回副图区域的说明文本 */
- (nullable NSAttributedString *)timeChartMinorAttributedText;

/** 返回副图区域每个索引所对应的信息(长按中) */
- (nullable NSAttributedString *)timeChart:(PKTimeChart *)timeChart attributedTextForMinorAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
