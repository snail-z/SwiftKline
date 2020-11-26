//
//  TQKTimeChartConfiguration.h
//  CoreGraphics_demo
//
//  Created by zhanghao on 2018/7/6.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TQTimeChartType) {
    TQTimeChartTypeDefault = 0, // 分时图
    TQTimeChartTypeFiveDay      // 五日分时图
};

@interface TQTimeChartStyle : NSObject

/** 分时图类型 */
@property (nonatomic, assign) TQTimeChartType chartType;

/** 分时最大数据量 */
@property (nonatomic, assign) NSInteger maxDataCount;

/**  日期栏位置，可选`top', `middle', `bottom'(默认"bottom') */
@property (nonatomic, strong) NSString *dateLocation;

/** 网格线颜色 (默认-[UIColor lightGrayColor]) */
@property (nonatomic, strong) UIColor *gridLineColor;

/** 网格线宽度 (默认1) */
@property (nonatomic, assign) CGFloat gridLineWidth;

/** 分时参考线宽度(虚线) (默认1) */
@property (nonatomic, assign) CGFloat dashLineWidth;

/** 分时参考线颜色 */
@property (nonatomic, strong) UIColor *dashLineColor;

/** 设置虚线长度和间隔 (默认@[@6, @5]，即长度为6，间隔为5) */
@property (nonatomic, strong, nullable) NSArray<NSNumber *> *dashLinePattern;

/** 分时图网格分割数量 */
@property (nonatomic, assign) NSInteger timeGridSegments;

/** 成交量网格分割数量 */
@property (nonatomic, assign) NSInteger volumeGirdSegments;

/** 成交量柱状条之间的间距 (默认5) */
@property (nonatomic, assign) CGFloat volumeShapeGap;

/** 成交量柱状条宽度 (根据间距volumeBarGap计算得出宽度) */
@property (nonatomic, assign, readonly) CGFloat volumeShapeWidth;

/** 成交量柱状条涨颜色 */
@property (nonatomic, strong) UIColor *volumeRiseColor;

/** 成交量柱状条跌颜色 */
@property (nonatomic, strong) UIColor *volumeFallColor;

/** 成交量柱状条平颜色 (默认-[UIColor grayColor]) */
@property (nonatomic, strong) UIColor *volumeFlatColor;

/** 设置图表中文本的颜色 */
@property (nonatomic, strong) UIColor *plainTextColor;

/** 设置图表中文本的字体 */
@property (nonatomic, strong) UIFont *plainTextFont;

/** 分时线线宽 */
@property (nonatomic, assign) CGFloat timeLineWith;

/** 分时线颜色 */
@property (nonatomic, strong) UIColor *timeLineColor;

/** 分时均线线宽 */
@property (nonatomic, assign) CGFloat avgTimeLineWidth;

/** 分时均线颜色 */
@property (nonatomic, strong) UIColor *avgTimeLineColor;

/** 分时线底部填充渐变色数组 (至少包含两个元素) */
@property (nonatomic, strong, nullable) NSArray<UIColor *> *timeLineFillGradientClolors;

/** 是否隐藏十字线(默认NO) */
@property (nonatomic, assign) BOOL crossLineHidden;

/** 十字线颜色 */
@property (nonatomic, strong) UIColor *crossLineColor;

/** 十字线宽度 */
@property (nonatomic, assign) CGFloat crossLineWidth;

/** 十字线映射的文本颜色 */
@property (nonatomic, strong) UIColor *crossTextColor;

/** 十字线文本背景色 */
@property (nonatomic, strong) UIColor *crossBackgroundColor;

+ (instancetype)defaultStyle;

@end

NS_ASSUME_NONNULL_END
