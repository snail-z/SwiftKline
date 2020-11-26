//
//  PKKLineChartSet.h
//  PKChartKit
//
//  Created by zhanghao on 2017/12/06.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKChartConst.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PKKLineChartPeriod) {
    /** 日K */
    PKKLineChartPeriodDay = 0,
    /** 周K */
    PKKLineChartPeriodWeek = 1,
    /** 月K */
    PKKLineChartPeriodMonth = 2,
    /** 季K */
    PKKLineChartPeriodQuarter = 3,
    /** 年K */
    PKKLineChartPeriodYear = 4,
    /** 1分钟K */
    PKKLineChartPeriodMin1 = 5,
    /** 5分钟K */
    PKKLineChartPeriodMin5 = 6,
    /** 15分钟K */
    PKKLineChartPeriodMin15 = 7,
    /** 30分钟K */
    PKKLineChartPeriodMin30 = 8,
    /** 60分钟K */
    PKKLineChartPeriodMin60 = 9,
    /** 120分钟K */
    PKKLineChartPeriodMin120 = 10
};

@interface PKKLineChartSet : NSObject

/** K线周期 */
@property (nonatomic, assign) PKKLineChartPeriod period;

/** K线数量，可视范围内K线显示的数量 (默认70根) <缩放时数量会动态改变，可以记录该值保存缩放状态> */
@property (nonatomic, assign) NSInteger numberOfVisible;

/** K线数量，可视范围内显示的最多数量 (默认120根) */
@property (nonatomic, assign) NSUInteger maxNumberOfVisible;

/** K线数量，可视范围内显示的最少数量 (默认20根) */
@property (nonatomic, assign) NSUInteger minNumberOfVisible;

/** 当缩放超出显示数量时，是否将K线图绘制成折线 (默认YES) */
@property (nonatomic, assign) BOOL pinchIntoLineEnabled;

/** K线图进入折线状态后，是否清除其它指标 (默认YES) */
@property (nonatomic, assign) BOOL pinchIntoLineCleared;

/** K线图进入折线状态后，可以继续缩放的数量 (默认50根) */
@property (nonatomic, assign) NSUInteger pinchIntoNumberOfScale;

/** K线图缩放成线的颜色 */
@property (nonatomic, strong) UIColor *pinchIntoLineColor;

/** K线图缩放成线的线宽 */
@property (nonatomic, assign) CGFloat pinchIntoLineWidth;

/** 设置图表中的数值精度，默认保留两位小数 */
@property (nonatomic, assign) NSInteger decimalKeepPlace;

/** 网格线颜色 (默认[UIColor lightGrayColor]) */
@property (nonatomic, strong) UIColor *gridLineColor;

/** 网格线宽度 (默认1px) */
@property (nonatomic, assign) CGFloat gridLineWidth;

/** 主图网格横向分割线数量 (majorNumberOfLines >= 1) */
@property (nonatomic, assign) NSInteger majorNumberOfLines;

/** K线图延伸线宽度 (默认1pt) */
@property (nonatomic, assign) CGFloat shapeStrokeWidth;

/** K线图初始间距 (默认为1.5pt，会根据K线数量自动调整间距) */
@property (nonatomic, assign) CGFloat shapeGap;

/** K线矩形框宽度 (由间距shapeGap和当前显示数量计算得出) */
@property (nonatomic, assign, readonly) CGFloat shapeWidth;

/** 涨K是否实心绘制 (默认NO) */
@property (nonatomic, assign) BOOL shouldRiseSolid;

/** 跌K是否实心绘制 (默认YES) */
@property (nonatomic, assign) BOOL shouldFallSolid;

/** 平K是否实心绘制 (默认YES) */
@property (nonatomic, assign) BOOL shouldFlatSolid;

/** 涨K颜色 */
@property (nonatomic, strong) UIColor *KRiseColor;

/** 跌K颜色 */
@property (nonatomic, strong) UIColor *KFallColor;

/** 平K颜色 */
@property (nonatomic, strong) UIColor *KFlatColor;

/** 设置图表中文本的颜色 */
@property (nonatomic, strong) UIColor *plainTextColor;

/** 设置图表中文本的字体 */
@property (nonatomic, strong) UIFont *plainTextFont;

/** 是否隐藏峰值点标记 (默认NO) */
@property (nonatomic, assign) BOOL peakTaggedHidden;

/** 峰值标记文本颜色 */
@property (nonatomic, strong) UIColor *peakTaggedTextColor;

/** 峰值标记文本字体 */
@property (nonatomic, strong) UIFont *peakTaggedTextFont;

/** 峰值标记边缘留白 (默认为10) */
@property (nonatomic, assign) CGFloat peakTaggedEdgePadding;

/** 峰值标记线宽度 (默认1px) */
@property (nonatomic, assign) CGFloat peakTaggedLineWidth;

/** 峰值标记线长度 (默认12pt) */
@property (nonatomic, assign) CGFloat peakTaggedLineLength;

/** 峰值标记线偏移位置 (默认偏移2pt间距) */
@property (nonatomic, assign) UIOffset peakTaggedLineOffset;

/** 峰值标记线顶端圆点半径 */
@property (nonatomic, assign) CGFloat peakTaggedVertexRadius;

/** 日期栏位置 (默认显示在底部) */
@property (nonatomic, assign) PKChartDatePosition datePosition;

/** 日期文本颜色 */
@property (nonatomic, strong) UIColor *dateTextColor;

/** 日期文本字体 */
@property (nonatomic, strong) UIFont *dateTextFont;

/** 长按是否显示十字线 (默认YES) */
@property (nonatomic, assign) BOOL showCrossLineOnLongPress;

/** 十字线是否约束在当前价格点 (默认NO) */
@property (nonatomic, assign) BOOL crossLineConstrained;

/** 十字线在多长时间后隐藏 (默认2s后隐藏) */
@property (nonatomic, assign) NSTimeInterval crossLineHiddenDuration;

/** 十字线颜色 */
@property (nonatomic, strong) UIColor *crossLineColor;

/** 十字线宽度 (默认1px) */
@property (nonatomic, assign) CGFloat crossLineWidth;

/** 十字线文本颜色 */
@property (nonatomic, strong) UIColor *crossTextColor;

/** 十字线文本背景色 */
@property (nonatomic, strong) UIColor *crossBackgroundColor;

/** 十字交叉点颜色 (默认[UIColor blackColor]) */
@property (nonatomic, strong) UIColor *crossDotColor;

/** 十字交叉点半径 (默认为0，不显示) */
@property (nonatomic, assign) CGFloat crossDotRadius;

/** 十字纵线提示视图后缀文本 */
@property (nonatomic, strong, nullable) NSString *crossSuffixText;

/** 更多加载视图偏移位置 (默认为0不显示加载视图) */
@property (nonatomic, assign) CGFloat pullLoadingInset;

/** 加载视图主色调 (默认[UIColor grayColor]) */
@property (nonatomic, strong, nullable) UIColor *pullLoadingTintColor;

/** 日期线防重叠设置的最小间距 (默认15pt) */
@property (nonatomic, assign) CGFloat avoidOverlapDatelineGap;

/** 主图高度占比 (默认0.6) */
@property (nonatomic, assign) CGFloat majorChartRatio;

/** 主图说明文本区域高度 (默认20pt) */
@property (nonatomic, assign) CGFloat majorLegendGap;

/** 副图说明文本区域高度 (默认20pt) */
@property (nonatomic, assign) CGFloat minorLegendGap;

/** 设置日期分隔区域大小 (默认20pt) */
@property (nonatomic, assign) CGFloat dateSeparatedGap;

/** 默认初始化 */
+ (instancetype)defaultSet;

@end

NS_ASSUME_NONNULL_END
