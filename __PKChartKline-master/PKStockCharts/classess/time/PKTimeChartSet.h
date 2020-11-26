//
//  PKTimeChartSet.h
//  PKChartKit
//
//  Created by zhanghao on 2017/11/27.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKChartConst.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PKTimeChartType) {
    /** 单日分时图 */
    PKTimeChartTypeOneDay = 1,
    /** 五日分时图 */
    PKTimeChartTypeFiveDays = 5
};

@interface PKTimeChartSet : NSObject

/** 走势类别 (默认PKTimeChartTypeOneDay) */
@property (nonatomic, assign) PKTimeChartType chartType;

/** 最大数据量 (默认242条数据点) */
@property (nonatomic, assign) NSInteger maxDataCount;

/** 设置图表中的数值精度，默认保留两位小数 */
@property (nonatomic, assign) NSInteger decimalKeepPlace;

/** 默认幅度，当没有数据、昨收为0或者极值相等时，涨跌幅为+-defaultChange (默认0.06) */
@property (nonatomic, assign) CGFloat defaultChange;

/** 网格线颜色 (默认[UIColor lightGrayColor]) */
@property (nonatomic, strong) UIColor *gridLineColor;

/** 网格线宽度 (默认1px) */
@property (nonatomic, assign) CGFloat gridLineWidth;

/** 主图网格横向分割线数量 (majorNumberOfLines >= 1) */
@property (nonatomic, assign) NSInteger majorNumberOfLines;

/** 副图网格横向分割线数量 (minorNumberOfLines >= 1) */
@property (nonatomic, assign) NSInteger minorNumberOfLines;

/** 参考线虚线宽度 (默认1pt设置为0则隐藏) */
@property (nonatomic, assign) CGFloat dashLineWidth;

/** 参考线颜色 */
@property (nonatomic, strong) UIColor *dashLineColor;

/** 参考线长度和间隔 (默认@[@6, @5]，即长度为6，间隔为5) */
@property (nonatomic, strong, nullable) NSArray<NSNumber *> *dashLinePattern;

/** 成交量柱状条之间的间距 (默认5) */
@property (nonatomic, assign) CGFloat shapeGap;

/** 成交量柱状条宽度 (根据间距shapeGap计算得出宽度) */
@property (nonatomic, assign, readonly) CGFloat shapeWidth;

/** 成交量柱状条涨颜色 */
@property (nonatomic, strong) UIColor *riseColor;

/** 成交量柱状条跌颜色 */
@property (nonatomic, strong) UIColor *fallColor;

/** 成交量柱状条平颜色 */
@property (nonatomic, strong) UIColor *flatColor;

/** 设置图表中文本的颜色 */
@property (nonatomic, strong) UIColor *plainTextColor;

/** 设置图表中文本的字体 */
@property (nonatomic, strong) UIFont *plainTextFont;

/** 分时线线宽 (默认1pt) */
@property (nonatomic, assign) CGFloat timeLineWidth;

/** 分时线颜色 */
@property (nonatomic, strong) UIColor *timeLineColor;

/** 分时线底部填充渐变色数组 */
@property (nonatomic, strong, nullable) NSArray<UIColor *> *timeLineFillGradientClolors;

/** 分时均线线宽 (默认1pt设置为0则隐藏) */
@property (nonatomic, assign) CGFloat avgTimeLineWidth;

/** 分时均线颜色 */
@property (nonatomic, strong) UIColor *avgTimeLineColor;

/** 持仓线线宽 (默认1pt设置为0则隐藏) */
@property (nonatomic, assign) CGFloat positionLineWidth;

/** 持仓线颜色 */
@property (nonatomic, strong) UIColor *positionLineColor;

/** 与timelineDisplayMinutes配合使用，用于精准绘制时间分割线，存储所有分时点的分钟数集 */
@property (nonatomic, strong, nullable) NSArray<NSNumber *> *timelineAllMinutes;

/** 与timelineAllMinutes配合使用，用于控制分割线绘制点，存储需要展示点的分钟数集 */
@property (nonatomic, strong, nullable) NSArray<NSNumber *> *timelineDisplayMinutes; // 以上两个属性主要用于分割线自定义，若未设置内部将均分绘制分割线

/** 设置分时图上的时间线文本 (配合timelineDisplayMinutes使用时，元素数量须一致，不足可用NSNull填充) */
@property (nonatomic, strong, nullable) NSArray<NSString *> *timelineDisplayTexts;

/** 日期栏位置 (默认显示在底部) */
@property (nonatomic, assign) PKChartDatePosition datePosition;

/** 格式化日期 (默认HH:mm) */
@property (nonatomic, strong, nullable) NSString *dateFormatter;

/** 十字线日期格式化 (默认HH:mm) */
@property (nonatomic, strong, nullable) NSString *crossDateFormatter;

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
@property (nonatomic, strong) UIColor *crossLineTextColor;

/** 十字线文本背景色 */
@property (nonatomic, strong) UIColor *crossLineBackgroundColor;

/** 十字交叉点颜色 (默认[UIColor blackColor]) */
@property (nonatomic, strong) UIColor *crossLineDotColor;

/** 十字交叉点半径 (默认为0，不显示) */
@property (nonatomic, assign) CGFloat crossLineDotRadius;

/** 是否显示雷达点 (默认YES) */
@property (nonatomic, assign) BOOL showFlashing;

/** 休市点分钟集 (用于设置休市前的点不闪动雷达) */
@property (nonatomic, strong) NSArray<NSNumber *> *flashingClosedMinutes;

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
