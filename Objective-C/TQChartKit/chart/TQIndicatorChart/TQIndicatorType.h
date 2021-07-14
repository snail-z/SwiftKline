//
//  TQIndicatorType.h
//  TQChartKit
//
//  Created by zhanghao on 2018/9/18.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 所有指标的唯一标识符 All indicators identifiers
UIKIT_EXTERN NSString * const TQIndicatorVOL;   // 成交量指标 volume
UIKIT_EXTERN NSString * const TQIndicatorBOLL;  // 布林线指标 Bollinger Bands
UIKIT_EXTERN NSString * const TQIndicatorMACD;  // 指数移动平均线 Moving Avg Convergence and Divergence
UIKIT_EXTERN NSString * const TQIndicatorKDJ;   // 随机指标 Stochastics
UIKIT_EXTERN NSString * const TQIndicatorOBV;   // 能量潮指标 On Balance Volume
UIKIT_EXTERN NSString * const TQIndicatorRSI;   // 相对强弱指标 Relative Strength Index
UIKIT_EXTERN NSString * const TQIndicatorWR;    // 威廉氏超买超卖指标 Williams Overbought/Oversold Index
UIKIT_EXTERN NSString * const TQIndicatorVR;    // 成交量变异率 Volume Ratio
UIKIT_EXTERN NSString * const TQIndicatorCR;    // 中间意愿指标、价格动量指标
UIKIT_EXTERN NSString * const TQIndicatorBIAS;  // 乖离率 (简称Y值也叫偏离率)
UIKIT_EXTERN NSString * const TQIndicatorCCI;   // 顺势指标 Commodity Channel Index
UIKIT_EXTERN NSString * const TQIndicatorDMI;   // 动向指标 Directional Movement Index
UIKIT_EXTERN NSString * const TQIndicatorDMA;   // 平行线差指标
UIKIT_EXTERN NSString * const TQIndicatorSAR;   // 抛物线指标 (停损点转向指标) Stop and Reverse
UIKIT_EXTERN NSString * const TQIndicatorPSY;   // 心理线指标 (情绪指标) Psychological Line
UIKIT_EXTERN NSString * const TQIndicatorMA;    // 移动平均线

// 缩略词转唯一标识符 e.g "KDJ" => "TQIndicatorKDJLayer"
UIKIT_EXTERN NSString* MakeIndicatorIdentifier(NSString *acronyms);

// 唯一标识符转缩略词 e.g "TQIndicatorKDJLayer" => "KDJ"
UIKIT_EXTERN NSString* MakeIndicatorAcronyms(NSString *identifier);





// 所有需要显示的分时K线文本唯一标识符
UIKIT_EXTERN NSString * const TQIndicatorVOL;   // 成交量指标 volume
UIKIT_EXTERN NSString * const TQIndicatorBOLL;  // 布林线指标 Bollinger Bands
UIKIT_EXTERN NSString * const TQIndicatorMACD;  // 指数移动平均线 Moving Avg Convergence and Divergence
UIKIT_EXTERN NSString * const TQIndicatorKDJ;   // 随机指标 Stochastics
UIKIT_EXTERN NSString * const TQIndicatorOBV;   // 能量潮指标 On Balance Volume
UIKIT_EXTERN NSString * const TQIndicatorRSI;   // 相对强弱指标 Relative Strength Index
UIKIT_EXTERN NSString * const TQIndicatorWR;    // 威廉氏超买超卖指标 Williams Overbought/Oversold Index
UIKIT_EXTERN NSString * const TQIndicatorVR;    // 成交量变异率 Volume Ratio
UIKIT_EXTERN NSString * const TQIndicatorCR;    // 中间意愿指标、价格动量指标
UIKIT_EXTERN NSString * const TQIndicatorBIAS;  // 乖离率 (简称Y值也叫偏离率)
UIKIT_EXTERN NSString * const TQIndicatorCCI;   // 顺势指标 Commodity Channel Index
UIKIT_EXTERN NSString * const TQIndicatorDMI;   // 动向指标 Directional Movement Index
UIKIT_EXTERN NSString * const TQIndicatorDMA;   // 平行线差指标
UIKIT_EXTERN NSString * const TQIndicatorSAR;   // 抛物线指标 (停损点转向指标) Stop and Reverse
UIKIT_EXTERN NSString * const TQIndicatorPSY;   // 心理线指标 (情绪指标) Psychological Line
UIKIT_EXTERN NSString * const TQIndicatorMA;    // 移动平均线

// 缩略词转唯一标识符 e.g "KDJ" => "TQIndicatorKDJLayer"
UIKIT_EXTERN NSString* MakeIndicatorIdentifier(NSString *acronyms);

// 唯一标识符转缩略词 e.g "TQIndicatorKDJLayer" => "KDJ"
UIKIT_EXTERN NSString* MakeIndicatorAcronyms(NSString *identifier);
NS_ASSUME_NONNULL_END
