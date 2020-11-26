//
//  PKTimeChartSet.m
//  PKChartKit
//
//  Created by zhanghao on 2017/11/27.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKTimeChartSet.h"

@implementation PKTimeChartSet

+ (instancetype)defaultSet {
    PKTimeChartSet *set = [PKTimeChartSet new];
    set.chartType = PKTimeChartTypeOneDay;
    set.maxDataCount = 242;
    
    set.decimalKeepPlace = 3;
    set.defaultChange = 0.06;
    
    set.gridLineWidth = 1 / [UIScreen mainScreen].scale;
    set.gridLineColor = PKCHART_GRIDLINE_COLOR;
    set.majorNumberOfLines = 2;
    set.minorNumberOfLines = 1;
    
    set.dashLineWidth = 1;
    set.dashLineColor = PKCHART_DASHLINE_COLOR;
    set.dashLinePattern = @[@6, @5];
    
    set.shapeGap = 0.5;
    set.riseColor = PKCHART_RISE_COLOR;
    set.fallColor = PKCHART_FALL_COLOR;
    set.flatColor = PKCHART_FLAT_COLOR;
    
    set.plainTextColor = [UIColor blackColor];
    set.plainTextFont = PKCHART_MAIN_FONTSIZE(10);
    
    set.timeLineWidth = 1;
    set.timeLineColor = PKCHART_RGB(62, 141, 247);
    UIColor *color1 = [set.timeLineColor colorWithAlphaComponent:0.5];
    UIColor *color2 = [set.timeLineColor colorWithAlphaComponent:0.1];
    set.timeLineFillGradientClolors = @[color1, color2];
    
    set.avgTimeLineWidth = 1;
    set.avgTimeLineColor = [UIColor orangeColor];
    
    set.positionLineWidth = 1;
    set.positionLineColor = [UIColor blueColor];
    
    set.timelineDisplayTexts = @[@"09:30", @"10:30", @"11:30/13:00", @"14:00", @"15:00"];
    set.datePosition = PKChartDatePositionBottom;
    set.dateFormatter = PKChartDateFormat_Hm;
    set.crossDateFormatter = PKChartDateFormat_Hm;
    
    set.showCrossLineOnLongPress = YES;
    set.crossLineConstrained = NO;
    set.crossLineHiddenDuration = 2.0;
    set.crossLineColor = [UIColor darkGrayColor];
    set.crossLineWidth = 1.f / [UIScreen mainScreen].scale;
    set.crossLineTextColor = PKCHART_RGB(30, 99, 255);
    set.crossLineBackgroundColor = [UIColor grayColor];
    set.crossLineDotRadius = 0;
    set.crossLineDotColor = [UIColor blackColor];
    
    set.showFlashing = YES;
    set.flashingClosedMinutes = @[@(690), @(900)];
    
    set.majorChartRatio = 0.6;
    set.majorLegendGap = 20;
    set.minorLegendGap = 20;
    set.dateSeparatedGap = 20;
    
    return set;
}

@end
