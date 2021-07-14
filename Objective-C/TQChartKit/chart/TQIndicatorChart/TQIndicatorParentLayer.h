//
//  TQIndicatorParentLayer.h
//  TQChartKit
//
//  Created by zhanghao on 2018/9/18.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TQStockChartProtocol.h"
#import "UIBezierPath+TQStockChart.h"
#import "NSArray+TQStockChart.h"
#import "TQIndicatorChartStyle.h"
#import "TQStockCacheModel.h"
#import "TQIndicatorType.h"

NS_ASSUME_NONNULL_BEGIN

@interface TQIndicatorParentLayer : CALayer

/** 原始数据源 */
@property (nonatomic, strong) NSArray<id<TQKlineChartProtocol>> *dataArray;

/** 缓存数据源 */
@property (nonatomic, strong) NSArray<TQStockCacheModel *> *cacheModels;

/** 配置外观样式 */
@property (nonatomic, strong) TQIndicatorChartStyle *styles;

/** 配置绘图数据 */
@property (nonatomic, assign) CGChartPlotter plotter;

/** 横轴坐标转换 */
@property (nonatomic, copy) CGaxisXConverBlock axisXCallback;

/** 纵轴坐标转换 */
@property (nonatomic, copy) CGaxisYConverBlock axisYCallback;

/** 子类实现该方法，更新样式 */
- (void)updateStyle;

/** 子类实现该方法，更新图表 */
- (void)updateChartInRange:(NSRange)range;

@end

@interface TQIndicatorParentLayer (DrawLine)

/** 根据evaluatedObject值，将某范围内的点连成折线 */
- (void)drawLineInRange:(NSRange)range atLayer:(CAShapeLayer *)layer evaluatedBlock:(CGFloat (NS_NOESCAPE ^)(TQStockCacheModel *_Nonnull evaluatedObject))block;;

/** 同上，该方法将跳过所有为0值的点 */
- (void)drawLineSkipZeroInRange:(NSRange)range atLayer:(CAShapeLayer *)layer evaluatedBlock:(CGFloat (^NS_NOESCAPE)(TQStockCacheModel * _Nonnull evaluatedObject))block;

@end

NS_ASSUME_NONNULL_END
