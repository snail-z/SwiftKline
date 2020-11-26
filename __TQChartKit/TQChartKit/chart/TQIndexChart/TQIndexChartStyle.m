//
//  TQIndexChartStyle.m
//  TQChartKit
//
//  Created by zhanghao on 2018/8/2.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndexChartStyle.h"

@implementation TQIndexChartStyle

+ (instancetype)defaultStyle {
    TQIndexChartStyle *style =  [TQIndexChartStyle new];
    
    style.VOLShouldFallSolid = YES;
    style.VOLShouldRiseSolid = YES;
    style.VOLRiseColor = TQChartRiseColor;
    style.VOLFallColor = TQChartFallColor;
    style.VOLFlatColor = TQChartFlatColor;
    style.VOLLineWidth = 1;
    
    style.OBVLineColor = [UIColor cyanColor];
    style.OBVLineColorM = [UIColor  yellowColor];
    style.OBVLineWidth = 1;
    
    style.KDJLineColorK = [UIColor redColor];
    style.KDJLineColorD = [UIColor yellowColor];
    style.KDJLineColorJ = [UIColor greenColor];
    style.KDJLineWidth = 1;
    
    return style;
}

@end
