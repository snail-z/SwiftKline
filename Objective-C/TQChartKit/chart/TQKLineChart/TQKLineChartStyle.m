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
    
    style.klineType = TQKLineTypeDay;
    
    style.numberOfVisual = 112; 
    style.maxNumberOfVisual = 200;
    style.minNumberOfVisual = 20;
    
    style.gridLineColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    style.gridLineWidth = 1 / [UIScreen mainScreen].scale;
    style.gridSegments = 2;
    
    style.shapeStrokeWidth = 1;
    style.shapeGap = 1.5;
    
    style.shouldRiseSolid = NO;
    style.shouldFallSolid = YES;
    style.shouldFlatSolid = YES;
    
    style.riseColor = TQChartRiseColor;
    style.fallColor = TQChartFallColor;
    style.flatColor = TQChartRiseColor;
    
    style.plainTextColor = [UIColor blackColor];
    style.plainTextFont = [UIFont fontWithName:TQChartThonburiBoldFontName size:9];
    
    style.peakTaggedInVisual = YES;
    style.peakTextColor = [UIColor blackColor];
    style.peakTextFont = [style.plainTextFont fontWithSize:9];
    style.peakEdgePadding = 15;
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
