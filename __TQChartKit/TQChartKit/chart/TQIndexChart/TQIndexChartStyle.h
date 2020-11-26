//
//  TQIndexChartStyle.h
//  TQChartKit
//
//  Created by zhanghao on 2018/8/2.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TQStockChartConst.h"

@interface TQIndexChartStyle : NSObject

#pragma mark - TQIndexVOLLayer

/** 涨成交量柱状图是否实心绘制 (默认-YES) */
@property (nonatomic, assign) BOOL VOLShouldRiseSolid;

/** 跌成交量柱状图是否实心绘制 (默认-YES) */
@property (nonatomic, assign) BOOL VOLShouldFallSolid;

/** 涨颜色 (默认-[UIColor redColor]) */
@property (nonatomic, strong) UIColor *VOLRiseColor;

/** 跌颜色 (默认-[UIColor greenColor]) */
@property (nonatomic, strong) UIColor *VOLFallColor;

/** 平颜色 (默认-[UIColor grayColor]) */
@property (nonatomic, strong) UIColor *VOLFlatColor;

/** 柱状图边框线宽 (默认1) */
@property (nonatomic, assign) CGFloat VOLLineWidth;

#pragma mark - TQIndexOBVLayer

/** 能量潮线颜色 */
@property (nonatomic, strong) UIColor *OBVLineColor;

/** 均量线颜色 */
@property (nonatomic, strong) UIColor *OBVLineColorM;

/** 线条宽度 */
@property (nonatomic, assign) CGFloat OBVLineWidth;

#pragma mark - TQIndexKDJLayer

@property (nonatomic, strong) UIColor *KDJLineColorK;
@property (nonatomic, strong) UIColor *KDJLineColorD;
@property (nonatomic, strong) UIColor *KDJLineColorJ;
@property (nonatomic, assign) CGFloat KDJLineWidth;

+ (instancetype)defaultStyle;

@end
