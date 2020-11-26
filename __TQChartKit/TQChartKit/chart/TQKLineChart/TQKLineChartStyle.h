//
//  TQKLineChartStyle.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/26.
//  Copyright © 2018年 zhanghao. All rights reserved.
//
    
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TQKLineType) {
    TQKLineTypeDayK = 0,    // 日K
    TQKLineTypeWeekK,       // 周K
    TQKLineTypeMonthK,      // 月K
    TQKLineTypeSeasonK,     // 季K
    TQKLineTypeYearK,       // 年K
    TQKLineTypeAllK         // 全历史K
};

@interface TQKLineChartStyle : NSObject

/** K线类型 (默认-TQKLineTypeDayK) */
@property (nonatomic, assign) TQKLineType klineType;

/** 可视范围内，显示K线的数量 (默认70根) */
@property (nonatomic, assign) NSUInteger numberOfVisual;

/** 可视范围内，显示K线的最多数量 (默认120根) */
@property (nonatomic, assign) NSUInteger maxNumberOfVisual;

/** 可视范围内，显示K线的最少数量 (默认20根) */
@property (nonatomic, assign) NSUInteger minNumberOfVisual;

/** 网格线颜色 (默认-[UIColor lightGrayColor]) */
@property (nonatomic, strong) UIColor *gridLineColor;

/** 网格线宽度 (默认1) */
@property (nonatomic, assign) CGFloat gridLineWidth;

/** K线图网格分割数量(如设置为2，则有3条坐标线) */
@property (nonatomic, assign) NSUInteger gridSegments;

/** 蜡烛图延伸线宽度 (默认1px) */
@property (nonatomic, assign) CGFloat shapeLineWidth;

/** 蜡烛图间的最大间距 (默认为5) */
@property (nonatomic, assign) CGFloat shapeGap;

/** K线矩形框宽度 (根据间距candleGap和显示数量计算得出) */
@property (nonatomic, assign, readonly) CGFloat shapeWidth;

/** 涨K线是否实心绘制 (默认-NO) */
@property (nonatomic, assign) BOOL shouldRiseSolid;

/** 跌K线是否实心绘制 (默认-YES) */
@property (nonatomic, assign) BOOL shouldFallSolid;

/** 平K线是否实心绘制 (默认-YES) */
@property (nonatomic, assign) BOOL shouldFlatSolid;

/** 涨颜色 (默认-[UIColor redColor]) */
@property (nonatomic, strong) UIColor *riseColor;

/** 跌颜色 (默认-[UIColor greenColor]) */
@property (nonatomic, strong) UIColor *fallColor;

/** 平颜色 (默认-[UIColor grayColor]) */
@property (nonatomic, strong) UIColor *flatColor;

/** 图表中主要文字颜色 (默认-[UIColor grayColor]) */
@property (nonatomic, strong) UIColor *plainTextColor;

/** 图表中主要文字字体 (默认-[UIFont systemFontOfSize:12]) */
@property (nonatomic, strong) UIFont *plainTextFont;

/** 是否标记当前显示范围内的峰值点 (默认YES) */
@property (nonatomic, assign) BOOL peakTaggedInVisual;

/** 峰值点文本颜色 */
@property (nonatomic, strong) UIColor *peakTextColor;

/** 峰值点文本字体 */
@property (nonatomic, strong) UIFont *peakTextFont;

/** 峰值点边缘间距 (默认为10) */
@property (nonatomic, assign) CGFloat peakEdgePadding;

/** 峰值标记线宽度 */
@property (nonatomic, assign) CGFloat peakLineWidth;

/** 峰值标记线长度 (默认12) */
@property (nonatomic, assign) CGFloat peakLineLength;

/** 峰值标记线偏移位置 (默认偏移2pt间距) */
@property (nonatomic, assign) UIOffset peakLineOffset;

/** 峰值标记线顶端圆点半径 */
@property (nonatomic, assign) CGFloat peakVertexRadius;

/** 长按是否显示十字线(默认YES) */
@property (nonatomic, assign) BOOL showCrossLineOnLongPress;

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
