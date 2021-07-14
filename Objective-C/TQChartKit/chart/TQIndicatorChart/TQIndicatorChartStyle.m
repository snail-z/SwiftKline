//
//  TQIndicatorChartStyle.m
//  TQChartKit
//
//  Created by zhanghao on 2018/8/2.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorChartStyle.h"
#import "TQStockChartConst.h"

@implementation TQIndicatorChartStyle

+ (instancetype)defaultStyle {
    TQIndicatorChartStyle *style =  [TQIndicatorChartStyle new];
    
    style.VOLShouldFallSolid = YES;
    style.VOLShouldRiseSolid = YES;
    style.VOLShouldFlatSolid = YES;
    style.VOLRiseColor = TQChartRiseColor;
    style.VOLFallColor = TQChartFallColor;
    style.VOLFlatColor = TQChartRiseColor;
    style.VOLLineWidth = 1;
    
    style.MA5LineColor = [UIColor zh_colorWithHexString:@"#008080"];
    style.MA10LineColor = [UIColor zh_colorWithHexString:@"#4169E1"];
    style.MA20LineColor = [UIColor zh_colorWithHexString:@"#8B008B"];
    style.MA60LineColor = [UIColor zh_colorWithHexString:@"#DAA520"];
    style.MALineWidth = 1;
    
    style.BOLLMBLineColor = [UIColor zh_colorWithHexString:@"#6495ED"];
    style.BOLLUPLineColor = TQChartRiseColor;
    style.BOLLDPLineColor = TQChartFallColor;
    style.BOLLLineWidth = 1;
    // 配置美式蜡烛线颜色(设置为nil时则使用成交量'涨'跌'平'颜色)
    style.BOLLKLineColor = [UIColor zh_colorWithHexString:@"#6495ED"];
    
    style.DMIPDILineColor = [UIColor orangeColor];
    style.DMIMDILineColor = [UIColor zh_colorWithHexString:@"#6495ED"];
    style.DMIADXLineColor = [UIColor purpleColor];
    style.DMIADXRLineColor = [UIColor magentaColor];
    style.DMILineWidth = 1;
    
    style.OBVLineColor = [UIColor zh_colorWithHexString:@"#6495ED"];
    style.OBVMLineColor = [UIColor orangeColor];
    style.OBVLineWidth = 1;
    
    style.MACDBarWidth = 1.2;
    style.MACDLineWidth = 1;
    style.DIFLineColor = [UIColor zh_colorWithHexString:@"#4169E1"];
    style.DEALineColor = [UIColor redColor];
    
    style.KDJLineColorK = [UIColor redColor];
    style.KDJLineColorD = [UIColor zh_colorWithHexString:@"#6495ED"];
    style.KDJLineColorJ = [UIColor zh_colorWithHexString:@"#3CB371"];
    style.KDJLineWidth = 1;
    
    style.CCILineColor = [UIColor purpleColor];
    style.CCILineWidth = 1;
    
    style.DMALineColor = [UIColor redColor];
    style.AMALineColor = [UIColor brownColor];
    style.DMALineWidth = 1;
    
    style.BIAS6LineColor = [UIColor orangeColor];
    style.BIAS12LineColor = [UIColor zh_colorWithHexString:@"#4169E1"];
    style.BIAS24LineColor = [UIColor zh_colorWithHexString:@"#CD5C5C"];
    style.BIASLineWidth = 1;
    
    style.WR6LineColor = [UIColor orangeColor];
    style.WR10LineColor = [UIColor zh_colorWithHexString:@"#6495ED"];
    style.WRLineWidth = 1;
    
    style.RSI6LineColor = [UIColor orangeColor];
    style.RSI12LineColor = [UIColor zh_colorWithHexString:@"#6495ED"];
    style.RSI24LineColor = [UIColor purpleColor];
    style.RSILineWidth = 1;
    
    style.PSYLineColor = [UIColor orangeColor];
    style.PSYMALineColor = [UIColor zh_colorWithHexString:@"#6495ED"];
    style.PSYLineWidth = 1;
    
    style.VR24LineColor = [UIColor orangeColor];
    style.VRLineWidth = 1;
    
    style.CR26LineColor = [UIColor orangeColor];
    style.CRLineWidth = 1;
    
    style.plainRefTextFont = [UIFont fontWithName:TQChartThonburiFontName size:11];
    style.plainRefTextColor = [UIColor blackColor];
    style.plainAxisTextFont = [UIFont fontWithName:TQChartThonburiBoldFontName size:10];
    style.plainAxisTextColor = [UIColor blackColor];
    return style;
}

@end
