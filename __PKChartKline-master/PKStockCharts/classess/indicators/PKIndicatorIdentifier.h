//
//  PKIndicatorIdentifier.h
//  PKChartKit
//
//  Created by zhanghao on 2017/12/26.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * PKIndicatorIdentifier NS_STRING_ENUM; /// 以下指标的Identifier默认为对应的类名

UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorVOL;   // 成交量指标 volume
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorMA;    // 移动平均线
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorBOLL;  // 布林线指标 Bollinger Bands
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorMACD;  // 指数移动平均线 Moving Avg Convergence and Divergence
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorKDJ;   // 随机指标 Stochastics
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorDMI;   // 动向指标 Directional Movement Index
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorOBV;   // 能量潮指标 On Balance Volume
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorRSI;   // 相对强弱指标 Relative Strength Index
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorASI;   // 振动升降指标 Accumulation Swing Index
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorWR;    // 威廉氏超买超卖指标 Williams Overbought/Oversold Index
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorVR;    // 成交量变异率 Volume Ratio
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorCR;    // 中间意愿指标、价格动量指标
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorBIAS;  // 乖离率 (简称Y值也叫偏离率)
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorCCI;   // 顺势指标 Commodity Channel Index
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorDMA;   // 平行线差指标
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorSAR;   // 抛物线指标 (停损点转向指标) Stop and Reverse
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorPSY;   // 心理线指标 (情绪指标) Psychological Line
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorEMA;   // 指数移动平均值 (EXPMA指标) Exponential Moving Average
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorTRIX;  // 三重指数平滑移动平均指标 Triple Exponentially Smoothed Average
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorBRAR;  // 人气意愿指标、由人气指标(AR)和意愿指标(BR)构成
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorEMV;   // 简易波动指标 Ease of Movement Value
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorWVAD;  // 威廉变异离散量 William's Variable Accumulation Distribution
UIKIT_EXTERN PKIndicatorIdentifier const PKIndicatorROC;   // 变动率指标 Price Rate of Change

NS_ASSUME_NONNULL_END
