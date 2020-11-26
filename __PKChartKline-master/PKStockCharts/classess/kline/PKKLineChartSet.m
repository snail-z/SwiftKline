//
//  PKKLineChartSet.m
//  PKChartKit
//
//  Created by zhanghao on 2017/12/06.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKKLineChartSet.h"
#import "PKChartConst.h"

@implementation PKKLineChartSet

+ (instancetype)defaultSet {
    PKKLineChartSet *set = [PKKLineChartSet new];
    set.period = PKKLineChartPeriodDay;
    
    set.numberOfVisible = 60;
    set.maxNumberOfVisible = 160;
    set.minNumberOfVisible = 15;
    
    set.pinchIntoLineEnabled = YES;
    set.pinchIntoLineCleared = YES;
    set.pinchIntoNumberOfScale = 50;
    set.pinchIntoLineColor = PKCHART_BROKENLINE_COLOR;
    set.pinchIntoLineWidth = 1;
    
    set.decimalKeepPlace = 3;
    set.gridLineColor = PKCHART_GRIDLINE_COLOR;
    set.gridLineWidth = 1 / [UIScreen mainScreen].scale;
    
    set.majorNumberOfLines = 2;
    
    set.shapeStrokeWidth = 1;
    set.shapeGap = 1.5;
    
    set.shouldRiseSolid = NO;
    set.shouldFallSolid = YES;
    set.shouldFlatSolid = YES;
    
    set.KRiseColor = PKCHART_RISE_COLOR;
    set.KFallColor = PKCHART_FALL_COLOR;
    set.KFlatColor = PKCHART_FLAT_COLOR;
    
    set.plainTextColor = [UIColor blackColor];
    set.plainTextFont = PKCHART_MAIN_FONTSIZE(9);
    
    set.peakTaggedHidden = NO;
    set.peakTaggedTextColor = PKCHART_RGB(0, 122, 255);
    set.peakTaggedTextFont = PKCHART_LEGEND_FONTSIZE(9);
    set.peakTaggedEdgePadding = 15;
    set.peakTaggedLineWidth = 1 / [UIScreen mainScreen].scale;
    set.peakTaggedLineLength = 12;
    set.peakTaggedLineOffset = UIOffsetMake(2, 2);
    set.peakTaggedVertexRadius = 1;
    
    set.datePosition = PKChartDatePositionBottom;
    set.dateTextColor = set.plainTextColor;
    set.dateTextFont = PKCHART_MAIN_FONTSIZE(10);
    
    set.showCrossLineOnLongPress = YES;
    set.crossLineConstrained = NO;
    set.crossLineHiddenDuration = 2.0;
    set.crossLineColor = [UIColor darkGrayColor];
    set.crossLineWidth = 1.f / [UIScreen mainScreen].scale;
    set.crossTextColor = PKCHART_RGB(30, 99, 255);
    set.crossBackgroundColor = [UIColor grayColor];
    set.crossDotColor = [UIColor blackColor];
    set.crossDotRadius = 0;
    
    set.pullLoadingInset = 0;
    set.pullLoadingTintColor = [UIColor grayColor];
    
    set.avoidOverlapDatelineGap = 15;
    
    set.majorChartRatio = 0.6;
    set.majorLegendGap = 20;
    set.minorLegendGap = 20;
    set.dateSeparatedGap = 20;
    
    return set;
}

@end
