//
//  UIBezierPath+PKStockChart.h
//  PKChartKit
//
//  Created by zhanghao on 2017/11/28.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSValue+PKGeometry.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (PKStockChart)

/** 绘制两点间连线 */
- (void)pk_addLine:(CGPoint)start end:(CGPoint)end;

/** 绘制横线 */
- (void)pk_addHorizontalLine:(CGPoint)start len:(CGFloat)len;

/** 绘制竖线 */
- (void)pk_addVerticalLine:(CGPoint)start len:(CGFloat)len;

/** 绘制矩形框 */
- (void)pk_addRect:(CGRect)rect;

/** 绘制蜡烛线 */
- (void)pk_addCandleShape:(CGCandleShape)shape;

/** 绘制蜡烛线(K线的另种形态) */
- (void)pk_addTwigCandleShape:(CGCandleShape)shape;

@end

NS_ASSUME_NONNULL_END
