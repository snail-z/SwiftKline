//
//  PKIndicatorBaseLayer.h
//  PKChartKit
//
//  Created by zhanghao on 2017/12/16.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PKKLineChartProtocol.h"
#import "PKIndicatorLayerProtocol.h"
#import "PKChartCategories.h"
#import "PKIndicatorCacheItem.h"
#import "PKIndicatorCycler.h"
#import "PKIndicatorChartSet.h"
#import "PKChartTextLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface PKIndicatorBaseLayer : CALayer 

/** 原始数据源 */
@property (nonatomic, copy, readonly) NSArray<id<PKKLineChartProtocol>> *dataList;

/** 缓存数据源 */
@property (nonatomic, copy, readonly) NSArray<PKIndicatorCacheItem *> *cacheList;

/** 图表样式 */
@property (nonatomic, strong, readonly) PKIndicatorChartSet *set;

/** 绘图所需数据 */
@property (nonatomic, assign, readonly) CGChartScaler scaler;

/** 横轴坐标转换 */
@property (nonatomic, copy, readonly) CGMakeXaxisBlock axisXCallback;

/** 纵轴坐标转换 */
@property (nonatomic, copy, readonly) CGMakeYaxisBlock axisYCallback;

@end

@interface PKIndicatorBaseLayer (DrawLines)

/** 根据evaluatedObject值，将某范围内的点连成折线 */
- (void)drawLineInRange:(NSRange)range
                atLayer:(CAShapeLayer *)layer
         evaluatedBlock:(CGFloat (NS_NOESCAPE ^)(PKIndicatorCacheItem *_Nonnull evaluatedObject))block;

/** 同上方法，将跳过所有为0值的点 */
- (void)drawLineSkipZeroInRange:(NSRange)range
                        atLayer:(CAShapeLayer *)layer
                 evaluatedBlock:(CGFloat (^NS_NOESCAPE)(PKIndicatorCacheItem * _Nonnull evaluatedObject))block;

@end

@interface PKIndicatorBaseLayer (SetValues)

/** 以下方法仅为内部提供使用 */
- (void)setValueForDataList:(NSArray<id<PKKLineChartProtocol>> *)dataList;
- (void)setValueForCacheList:(NSArray<PKIndicatorCacheItem *> *)cacheList;
- (void)setValueForSet:(PKIndicatorChartSet *)set;
- (void)setValueForScaler:(CGChartScaler)scaler;
- (void)setValueForAxisXCallback:(CGMakeXaxisBlock)axisXCallback;
- (void)setValueForAxisYCallback:(CGMakeYaxisBlock)axisYCallback;

@end

NS_ASSUME_NONNULL_END
