//
//  PKIndicatorChartSet.m
//  PKChartKit
//
//  Created by zhanghao on 2017/12/15.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKIndicatorChartSet.h"
#import "PKChartConst.h"

@implementation PKIndicatorChartSet

+ (instancetype)defaultSet {
    PKIndicatorChartSet *set = [PKIndicatorChartSet new];
    
    set.MAALineColor = PKCHART_RGB(0, 128, 128);
    set.MABLineColor = PKCHART_RGB(65, 105, 225);
    set.MACLineColor = PKCHART_RGB(139, 0, 139);
    set.MADLineColor = PKCHART_RGB(218, 165, 32);
    set.MAELineColor = PKCHART_RGB(255, 69, 0);
    set.MALineWidth = 1;
    set.MAALineDisplayed = YES;
    set.MABLineDisplayed = YES;
    set.MACLineDisplayed = YES;
    set.MADLineDisplayed = YES;
    set.MAELineDisplayed = YES;

    set.VOLRiseColor = PKCHART_RISE_COLOR;
    set.VOLFallColor = PKCHART_FALL_COLOR;
    set.VOLFlatColor = PKCHART_FLAT_COLOR;
    set.VOLShouldFallSolid = YES;
    set.VOLShouldRiseSolid = YES;
    set.VOLShouldFlatSolid = YES;
    set.VOLMAALineColor = set.MAALineColor;
    set.VOLMABLineColor = set.MABLineColor;
    set.VOLMACLineColor = set.MACLineColor;
    set.VOLMADLineColor = set.MADLineColor;
    set.VOLLineWidth = 1;
    set.VOLMAALineDisplayed = YES;
    set.VOLMABLineDisplayed = YES;
    set.VOLMACLineDisplayed = YES;
    set.VOLMADLineDisplayed = YES;

    set.BOLLMBLineColor = PKCHART_RGB(100,149,237);
    set.BOLLUPLineColor = PKCHART_RISE_COLOR;
    set.BOLLDPLineColor = PKCHART_FALL_COLOR;
    set.BOLLKLineColor = nil;
    set.BOLLLineWidth = 1;
    
    set.DIFFLineColor = PKCHART_RGB(65, 105, 225);
    set.DEALineColor = [UIColor redColor];
    set.MACDTintColor = [UIColor purpleColor];
    set.MACDLineWidth = 1;
    
    set.DMIPDILineColor = [UIColor orangeColor];
    set.DMIMDILineColor = PKCHART_RGB(100, 149, 237);
    set.DMIADXLineColor = [UIColor purpleColor];
    set.DMIADXRLineColor = [UIColor magentaColor];
    set.DMILineWidth = 1;

    set.OBVLineColor = PKCHART_RGB(100, 149, 237);
    set.OBVMLineColor = [UIColor orangeColor];
    set.OBVLineWidth = 1;

    set.KDJKLineColor = [UIColor redColor];
    set.KDJDLineColor = PKCHART_RGB(100, 149, 237);
    set.KDJJLineColor = PKCHART_RGB(60, 179, 113);
    set.KDJLineWidth = 1;

    set.CCILineColor = [UIColor purpleColor];
    set.CCILineWidth = 1;
    
    set.DMALineColor = [UIColor redColor];
    set.AMALineColor = [UIColor brownColor];
    set.DMALineWidth = 1;
    
    set.BIAS6LineColor = [UIColor orangeColor];
    set.BIAS12LineColor = PKCHART_RGB(65, 105, 225);
    set.BIAS24LineColor = PKCHART_RGB(205, 92, 92);
    set.BIASLineWidth = 1;

    set.WR6LineColor = [UIColor orangeColor];
    set.WR10LineColor = PKCHART_RGB(100, 149, 237);
    set.WRLineWidth = 1;
    
    set.VR24LineColor = [UIColor orangeColor];
    set.VRLineWidth = 1;
    
    set.CR26LineColor = [UIColor orangeColor];
    set.CRLineWidth = 1;

    set.RSI6LineColor = [UIColor orangeColor];
    set.RSI12LineColor = PKCHART_RGB(100, 149, 237);
    set.RSI24LineColor = [UIColor purpleColor];
    set.RSILineWidth = 1;
    
    set.PSYLineColor = [UIColor orangeColor];
    set.PSYMALineColor = PKCHART_RGB(100, 149, 237);
    set.PSYLineWidth = 1;
    
    set.legendTextColor = [UIColor blackColor];
    set.legendTextFont = PKCHART_LEGEND_FONTSIZE(10);
    set.plainTextColor = [UIColor blackColor];
    set.plainTextFont = PKCHART_MAIN_FONTSIZE(9);
    set.decimalKeepPlace = 3;
    
    return set;
}

@end
