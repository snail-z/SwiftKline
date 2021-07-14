//
//  UIBezierPath+TQChart.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStockChartUtilities.h"

@interface UIBezierPath (TQStockChart)

/** 绘制两点间连线 */
- (void)addLine:(CGPoint)start end:(CGPoint)end;

/** 绘制横线 */
- (void)addHorizontalLine:(CGPoint)start len:(CGFloat)len;

/** 绘制竖线 */
- (void)addVerticalLine:(CGPoint)start len:(CGFloat)len;

/** 绘制矩形框 */
- (void)addRect:(CGRect)rect;

/** 绘制蜡烛线 */
- (void)addCandleShape:(CGCandleShape)shape;

/** 绘制蜡烛线(K线的另种形态) */
- (void)addTwigCandleShape:(CGCandleShape)shape;

@end
