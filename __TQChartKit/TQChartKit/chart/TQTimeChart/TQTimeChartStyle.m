//
//  TQKTimeChartConfiguration.m
//  CoreGraphics_demo
//
//  Created by zhanghao on 2018/7/6.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import "TQTimeChartStyle.h"
#import "TQStockChartConst.h"

@implementation TQTimeChartStyle

+ (instancetype)defaultStyle {
    TQTimeChartStyle *style = [TQTimeChartStyle new];
    style.chartType = TQTimeChartTypeDefault;
    
    // 港股最大242 (9:30~11:30 13:00~15:00，每分钟一条数据，共计242条)
    style.maxDataCount = 242;
    
    style.dateLocation = @"bottom";
    style.gridLineWidth = 1 / [UIScreen mainScreen].scale;
    style.gridLineColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    style.dashLineWidth = 1;
    style.dashLineColor = [UIColor zh_r:147 g:112 b:219];
    style.dashLinePattern = @[@6, @5];
    
    style.volumeShapeGap = 0.5;
    style.volumeRiseColor = [UIColor zh_r:218 g:59 b:34];
    style.volumeFallColor = [UIColor zh_r:68 g:162 b:61];
    style.volumeFlatColor = [UIColor lightGrayColor];
    
    style.plainTextColor = [UIColor blackColor];
    style.plainTextFont = [UIFont fontWithName:TQChartThonburiFontName size:11];
    
    style.timeGridSegments = 2;
    style.volumeGirdSegments = 2;
    
    style.timeLineWith = 1;
    style.timeLineColor = [UIColor zh_r:62 g:141 b:247];
    UIColor *color1 = [style.timeLineColor colorWithAlphaComponent:0.5];
    UIColor *color2 = [style.timeLineColor colorWithAlphaComponent:0.1];
    style.timeLineFillGradientClolors = @[color1, color2];
    
    style.avgTimeLineWidth = 1;
    style.avgTimeLineColor = [UIColor orangeColor];
    
    style.crossLineHidden = NO;
    style.crossLineColor = [UIColor darkGrayColor];
    style.crossLineWidth = 1.f / [UIScreen mainScreen].scale;
    style.crossTextColor = [UIColor zh_r:30 g:99 b:255];
    style.crossBackgroundColor = [UIColor grayColor];
    
    return style;
}

@end
