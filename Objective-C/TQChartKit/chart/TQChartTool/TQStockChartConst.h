//
//  TQStockChartConst.h
//  TQChartKit
//
//  Created by zhanghao on 2018/8/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

// RGB颜色
#define TQChartColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 普通文字颜色
#define TQChartLabelTextColor TQChartColor(90, 90, 90)

// 普通字体大小
#define TQChartTextFont [UIFont boldSystemFontOfSize:14]

// 涨颜色
#define TQChartRiseColor TQChartColor(218, 59, 34)

// 跌颜色
#define TQChartFallColor TQChartColor(68, 162, 61)

// 平颜色
#define TQChartFlatColor TQChartColor(28, 50, 34)

// 字体 (Thonburi)
#define TQChartThonburiFontName @"Thonburi"

// 字体 (Thonburi-Bold)
#define TQChartThonburiBoldFontName @"Thonburi-Bold"

// 文本格式
#define TQPlainTextFormat(value) [NSString stringWithFormat:@"%.2f", value]

// 长按日K日期格式
#ifndef TQTouchDaysKDateFormatter
#define TQTouchDaysKDateFormatter @"yyyy-MM-dd"
#endif

#define TQPlainDaysKDateFormatter @"yyyy-MM"

// 长按分钟K日期格式
#define TQMinuteKTouchDateFormatter @"MM-dd HH:mm"

// 长按分时图日期格式
#define TQChartTimeTouchDateFormatter @"HH:mm"

// 长按五日分时图日期格式
#define TQChartFiveTimeTouchDateFormatter @"MM-dd HH:mm"
