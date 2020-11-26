//
//  PKChartConst.h
//  PKChartKit
//
//  Created by zhanghao on 2017/11/28.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 图表绘制区域类型
typedef NS_ENUM(NSUInteger, PKChartRegionType) {
    /** 主图区域 */
    PKChartRegionTypeMajor = 0,
    /** 副图区域 */
    PKChartRegionTypeMinor
};

// 图表日期栏位置
typedef NS_ENUM(NSUInteger, PKChartDatePosition) {
    /** 日期栏位置将在顶部 */
    PKChartDatePositionTop = 0,
    /** 日期栏位置在中间 */
    PKChartDatePositionMiddle,
    /** 日期栏位置在底部 */
    PKChartDatePositionBottom
};

// yyyy格式化日期
UIKIT_EXTERN NSString *const PKChartDateFormat_y;

// yyyy-MM格式化日期
UIKIT_EXTERN NSString *const PKChartDateFormat_yM;

// yyyy-MM-dd格式化日期
UIKIT_EXTERN NSString *const PKChartDateFormat_yMd;

// yyyy-MM-dd HH:mm格式化日期
UIKIT_EXTERN NSString *const PKChartDateFormat_yMdHm;

// yyyy-MM-dd HH:mm:ss格式化日期
UIKIT_EXTERN NSString *const PKChartDateFormat_yMdHms;

// MM-dd HH:mm格式化日期
UIKIT_EXTERN NSString *const PKChartDateFormat_MdHm;

// MM-dd格式化日期
UIKIT_EXTERN NSString *const PKChartDateFormat_Md;

// HH:mm格式化日期
UIKIT_EXTERN NSString *const PKChartDateFormat_Hm;

// 十字线纵线提示后缀文本
UIKIT_EXTERN NSString *const PKChartCrossSuffixText;


// RGB颜色
#define PKCHART_RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 网格线颜色
#define PKCHART_GRIDLINE_COLOR PKCHART_RGB(235, 235, 235)

// 虚线颜色
#define PKCHART_DASHLINE_COLOR PKCHART_RGB(147, 112, 219)

// 涨颜色
#define PKCHART_RISE_COLOR PKCHART_RGB(218, 59, 34)

// 跌颜色
#define PKCHART_FALL_COLOR PKCHART_RGB(68, 162, 61)

// 平颜色
#define PKCHART_FLAT_COLOR PKCHART_RGB(105, 105, 105)

// K线折线颜色
#define PKCHART_BROKENLINE_COLOR PKCHART_RGB(65, 105, 225)

// 普通文字颜色
#define PKCHART_PLAIN_COLOR PKCHART_RGB(90, 90, 90)


// 图表主要字体
#define pkchart_main_fontname @"Charter-Roman"
#define _pkchart_main_fontsize_(p) \
[UIFont fontWithName:pkchart_main_fontname size:p] ? \
[UIFont fontWithName:pkchart_main_fontname size:p] : [UIFont systemFontOfSize:p]
#define PKCHART_MAIN_FONTSIZE(p) _pkchart_main_fontsize_(p)

// 说明文本字体(legend)
#define pkchart_legend_fontname @"Kefa-Regular"
#define _pkchart_legend_fontsize_(p)\
[UIFont fontWithName:pkchart_legend_fontname size:p] ? \
[UIFont fontWithName:pkchart_legend_fontname size:p] : [UIFont systemFontOfSize:p]
#define PKCHART_LEGEND_FONTSIZE(p) _pkchart_legend_fontsize_(p)

// 普通字体
#define PKCHART_PLAIN_FONTSIZE(p) [UIFont boldSystemFontOfSize:p]


// 禁止隐式动画
#ifndef disable_animations
#define disable_animations(block)\
[CATransaction begin];\
[CATransaction setDisableActions:YES];\
block();\
[CATransaction commit];
#endif

// 日志输出
#ifndef __OPTIMIZE__
#define PKChartLog(s, ...) NSLog(@"** PKChartKit ** [%@ in line %d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define PKChartLog(...) {}
#endif

NS_ASSUME_NONNULL_END
