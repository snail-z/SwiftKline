//
//  PKTimePileBaseLayer.h
//  PKStockCharts
//
//  Created by zhanghao on 2019/8/8.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PKChartCategories.h"
#import "PKTimeChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PKTimePileBaseLayer : CALayer

/** 原始数据源 */
@property (nonatomic, strong, readonly) NSArray<id<PKTimeChartProtocol>> *dataList;

/** 绘图所需数据 */
@property (nonatomic, assign, readonly) CGChartScaler scaler;

/** 横轴坐标转换 */
@property (nonatomic, copy, readonly) CGMakeXaxisBlock axisXCallback;

/** 纵轴坐标转换 */
@property (nonatomic, copy, readonly) CGMakeYaxisBlock axisYCallback;

@end

@interface PKTimePileBaseLayer (DrawLines)

/** 根据evaluatedObject值，绘制通过该点的横线 */
- (void)drawHorizontalLineInLayer:(CAShapeLayer *)layer
                   evaluatedBlock:(CGFloat (^_Nonnull NS_NOESCAPE)(void))block;

/** 根据evaluatedObject值，绘制通过该点的竖线 */
- (void)drawVerticalLineInLayer:(CAShapeLayer *)layer
                 evaluatedBlock:(CGFloat (^_Nonnull NS_NOESCAPE)(void))block;

/** 根据evaluatedObject值，将数组内所有点连成折线 */
- (void)drawLineInLayer:(CAShapeLayer *)layer
         evaluatedBlock:(CGFloat (NS_NOESCAPE ^)(id<PKTimeChartProtocol> _Nonnull evaluatedObject))block;

/** 同上方法，将跳过所有为0值的点 */
- (void)drawLineSkipZeroInLayer:(CAShapeLayer *)layer
                 evaluatedBlock:(CGFloat (NS_NOESCAPE ^)(id<PKTimeChartProtocol> _Nonnull evaluatedObject))block;

@end

@interface PKTimePileBaseLayer (SetValues)

/** 以下方法内部使用 */
- (void)setValueForDataList:(NSArray<id<PKTimeChartProtocol>> *)dataList;
- (void)setValueForScaler:(CGChartScaler)scaler;
- (void)setValueForAxisXCallback:(CGMakeXaxisBlock)axisXCallback;
- (void)setValueForAxisYCallback:(CGMakeYaxisBlock)axisYCallback;

@end

NS_ASSUME_NONNULL_END
