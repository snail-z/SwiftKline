//
//  TQKLineChartStyle.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/26.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQKLineChartStyle.h"
#import "TQStockChartConst.h"

@implementation TQKLineChartStyle

+ (instancetype)defaultStyle {
    TQKLineChartStyle *style = [TQKLineChartStyle new];
    
    style.klineType = TQKLineTypeDayK;
    
    style.numberOfVisual = 50;
    style.maxNumberOfVisual = 120;
    style.minNumberOfVisual = 20;
    
    style.gridLineColor = [UIColor lightGrayColor];
    style.gridLineWidth = 0.5 / [UIScreen mainScreen].scale;
    style.gridSegments = 2;
    
    style.shapeLineWidth = 1;
    style.shapeGap = 2.5;
    
    style.shouldRiseSolid = NO;
    style.shouldFallSolid = YES;
    style.shouldFlatSolid = YES;
    
    style.riseColor = TQChartRiseColor;
    style.fallColor = TQChartFallColor;
    style.flatColor = TQChartFlatColor;
    
    style.plainTextColor = [UIColor blackColor];
    style.plainTextFont = [UIFont fontWithName:TQChartThonburiBoldFontName size:9];
    
    style.peakTaggedInVisual = YES;
    style.peakTextColor = style.plainTextColor;
    style.peakTextFont = style.plainTextFont;
    style.peakEdgePadding = 10;
    style.peakLineWidth = 1 / [UIScreen mainScreen].scale;
    style.peakLineLength = 12;
    style.peakLineOffset = UIOffsetMake(2, 2);
    style.peakVertexRadius = 1;
    
    style.showCrossLineOnLongPress = YES;
    style.crossLineColor = [UIColor grayColor];
    style.crossLineWidth = 1 / [UIScreen mainScreen].scale;
    style.crossTextColor = [UIColor blueColor];
    style.crossBackgroundColor = [UIColor grayColor];
    
    return style;
}

@end
