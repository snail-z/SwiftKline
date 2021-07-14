//
//  TQIndicatorChartStyle.h
//  TQChartKit
//
//  Created by zhanghao on 2018/8/2.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TQIndicatorChartStyle : NSObject

// VOL
@property (nonatomic, assign) BOOL VOLShouldRiseSolid;
@property (nonatomic, assign) BOOL VOLShouldFallSolid;
@property (nonatomic, assign) BOOL VOLShouldFlatSolid;
@property (nonatomic, strong) UIColor *VOLRiseColor;
@property (nonatomic, strong) UIColor *VOLFallColor;
@property (nonatomic, strong) UIColor *VOLFlatColor;
@property (nonatomic, assign) CGFloat VOLLineWidth;

// MA
@property (nonatomic, strong) UIColor *MA5LineColor;
@property (nonatomic, strong) UIColor *MA10LineColor;
@property (nonatomic, strong) UIColor *MA20LineColor;
@property (nonatomic, strong) UIColor *MA60LineColor;
@property (nonatomic, assign) CGFloat MALineWidth;

// BOLL
@property (nonatomic, strong) UIColor *BOLLMBLineColor;
@property (nonatomic, strong) UIColor *BOLLUPLineColor;
@property (nonatomic, strong) UIColor *BOLLDPLineColor;
@property (nonatomic, assign) CGFloat BOLLLineWidth;
@property (nonatomic, strong) UIColor *BOLLKLineColor; 

// DMI
@property (nonatomic, strong) UIColor *DMIPDILineColor;
@property (nonatomic, strong) UIColor *DMIMDILineColor;
@property (nonatomic, strong) UIColor *DMIADXLineColor;
@property (nonatomic, strong) UIColor *DMIADXRLineColor;
@property (nonatomic, assign) CGFloat DMILineWidth;

// OBV
@property (nonatomic, strong) UIColor *OBVLineColor;
@property (nonatomic, strong) UIColor *OBVMLineColor;
@property (nonatomic, assign) CGFloat OBVLineWidth;

// MACD
@property (nonatomic, assign) CGFloat MACDBarWidth;
@property (nonatomic, assign) CGFloat MACDLineWidth;
@property (nonatomic, strong) UIColor *DIFLineColor;
@property (nonatomic, strong) UIColor *DEALineColor;

// KDJ
@property (nonatomic, strong) UIColor *KDJLineColorK;
@property (nonatomic, strong) UIColor *KDJLineColorD;
@property (nonatomic, strong) UIColor *KDJLineColorJ;
@property (nonatomic, assign) CGFloat KDJLineWidth;

// CCI
@property (nonatomic, strong) UIColor *CCILineColor;
@property (nonatomic, assign) CGFloat CCILineWidth;

// DMA
@property (nonatomic, strong) UIColor *DMALineColor;
@property (nonatomic, strong) UIColor *AMALineColor;
@property (nonatomic, assign) CGFloat DMALineWidth;

// BIAS
@property (nonatomic, strong) UIColor *BIAS6LineColor;
@property (nonatomic, strong) UIColor *BIAS12LineColor;
@property (nonatomic, strong) UIColor *BIAS24LineColor;
@property (nonatomic, assign) CGFloat BIASLineWidth;

// WR
@property (nonatomic, strong) UIColor *WR6LineColor;
@property (nonatomic, strong) UIColor *WR10LineColor;
@property (nonatomic, assign) CGFloat WRLineWidth;

// VR
@property (nonatomic, strong) UIColor *VR24LineColor;
@property (nonatomic, assign) CGFloat VRLineWidth;

// CR
@property (nonatomic, strong) UIColor *CR26LineColor;
@property (nonatomic, assign) CGFloat CRLineWidth;

// RSI
@property (nonatomic, strong) UIColor *RSI6LineColor;
@property (nonatomic, strong) UIColor *RSI12LineColor;
@property (nonatomic, strong) UIColor *RSI24LineColor;
@property (nonatomic, assign) CGFloat RSILineWidth;

// PSY
@property (nonatomic, strong) UIColor *PSYLineColor;
@property (nonatomic, strong) UIColor *PSYMALineColor;
@property (nonatomic, assign) CGFloat PSYLineWidth;

// Standard font/color
@property (nonatomic, strong) UIFont *plainRefTextFont;
@property (nonatomic, strong) UIColor *plainRefTextColor;
@property (nonatomic, strong) UIFont *plainAxisTextFont;
@property (nonatomic, strong) UIColor *plainAxisTextColor;

+ (instancetype)defaultStyle;

@end

NS_ASSUME_NONNULL_END
