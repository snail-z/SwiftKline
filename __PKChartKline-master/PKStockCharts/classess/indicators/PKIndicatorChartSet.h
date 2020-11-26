//
//  PKIndicatorChartSet.h
//  PKChartKit
//
//  Created by zhanghao on 2017/12/15.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKIndicatorChartSet : NSObject

// VOL
@property (nonatomic, strong) UIColor *VOLRiseColor;
@property (nonatomic, strong) UIColor *VOLFallColor;
@property (nonatomic, strong) UIColor *VOLFlatColor;
@property (nonatomic, assign) BOOL VOLShouldRiseSolid;
@property (nonatomic, assign) BOOL VOLShouldFallSolid;
@property (nonatomic, assign) BOOL VOLShouldFlatSolid;
@property (nonatomic, strong) UIColor *VOLMAALineColor;
@property (nonatomic, strong) UIColor *VOLMABLineColor;
@property (nonatomic, strong) UIColor *VOLMACLineColor;
@property (nonatomic, strong) UIColor *VOLMADLineColor;
@property (nonatomic, assign) CGFloat VOLLineWidth;
@property (nonatomic, assign) BOOL VOLMAALineDisplayed;
@property (nonatomic, assign) BOOL VOLMABLineDisplayed;
@property (nonatomic, assign) BOOL VOLMACLineDisplayed;
@property (nonatomic, assign) BOOL VOLMADLineDisplayed;

// MA
@property (nonatomic, strong) UIColor *MAALineColor;
@property (nonatomic, strong) UIColor *MABLineColor;
@property (nonatomic, strong) UIColor *MACLineColor;
@property (nonatomic, strong) UIColor *MADLineColor;
@property (nonatomic, strong) UIColor *MAELineColor;
@property (nonatomic, assign) CGFloat MALineWidth;
@property (nonatomic, assign) BOOL MAALineDisplayed;
@property (nonatomic, assign) BOOL MABLineDisplayed;
@property (nonatomic, assign) BOOL MACLineDisplayed;
@property (nonatomic, assign) BOOL MADLineDisplayed;
@property (nonatomic, assign) BOOL MAELineDisplayed;

// BOLL
@property (nonatomic, strong) UIColor *BOLLMBLineColor;
@property (nonatomic, strong) UIColor *BOLLUPLineColor;
@property (nonatomic, strong) UIColor *BOLLDPLineColor;
@property (nonatomic, strong, nullable) UIColor *BOLLKLineColor; /// 默认nil使用K线'涨'跌'平'颜色
@property (nonatomic, assign) CGFloat BOLLLineWidth;

// MACD
@property (nonatomic, strong) UIColor *DIFFLineColor;
@property (nonatomic, strong) UIColor *DEALineColor;
@property (nonatomic, strong) UIColor *MACDTintColor;
@property (nonatomic, assign) CGFloat MACDLineWidth;
@property (nonatomic, assign) CGFloat MACDBarWidth;

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

// KDJ
@property (nonatomic, strong) UIColor *KDJKLineColor;
@property (nonatomic, strong) UIColor *KDJDLineColor;
@property (nonatomic, strong) UIColor *KDJJLineColor;
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

// Other
@property (nonatomic, strong) UIColor *legendTextColor;
@property (nonatomic, strong) UIFont *legendTextFont;
@property (nonatomic, strong) UIColor *plainTextColor;
@property (nonatomic, strong) UIFont *plainTextFont;
@property (nonatomic, assign) NSInteger decimalKeepPlace;

+ (instancetype)defaultSet;

@end

NS_ASSUME_NONNULL_END
