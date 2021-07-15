//
//  TQKTimeChartConfiguration.m
//  CoreGraphics_demo
//
//  Created by zhanghao on 2018/7/6.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import "TQTimeChartConfiguration.h"

@implementation TQTimeChartConfiguration

+ (instancetype)defaultConfiguration {
    TQTimeChartConfiguration *configuration = [TQTimeChartConfiguration new];
    configuration.chartType = TQTimeChartTypeDefault;
    
    // 港股最大242 (9:30~11:30 13:00~15:00，每分钟一条数据，共计242条)
    configuration.maxDataCount = 242;
    
    configuration.dateLocation = @"bottom";
    configuration.gridLineWidth = 1 / [UIScreen mainScreen].scale;
    configuration.gridLineColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    configuration.dashLineWidth = 1;
    configuration.dashLineColor = [UIColor zh_r:147 g:112 b:219];
    configuration.dashLinePattern = @[@6, @5];
    
    configuration.volumeBarGap = 0.5;
    configuration.volumeRiseColor = [UIColor zh_r:218 g:59 b:34];
    configuration.volumeFallColor = [UIColor zh_r:68 g:162 b:61];
    configuration.volumeFlatColor = [UIColor lightGrayColor];
    
    configuration.textColor = [UIColor blackColor];
    configuration.textFont = [UIFont fontWithName:@"Thonburi" size:11];
    
    configuration.yAxisTimeSegments = 2;
    configuration.yAxisVolumeSegments = 2;
    
    configuration.timeLineWith = 1;
    configuration.timeLineColor = [UIColor zh_r:62 g:141 b:247];
    UIColor *color1 = [configuration.timeLineColor colorWithAlphaComponent:0.5];
    UIColor *color2 = [configuration.timeLineColor colorWithAlphaComponent:0.1];
    configuration.timeLineFillGradientClolors = @[color1, color2];
    
    configuration.avgTimeLineWidth = 1;
    configuration.avgTimeLineColor = [UIColor orangeColor];
    
    configuration.crosswireLineColor = [UIColor darkGrayColor];
    configuration.crosswireLineWidth = 1.f / [UIScreen mainScreen].scale;
    configuration.crosswireTextColor = [UIColor zh_r:30 g:99 b:255];
    return configuration;
}

@end
