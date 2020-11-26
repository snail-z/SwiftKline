//
//  TQIndexBaseLayer.h
//  TQChartKit
//
//  Created by zhanghao on 2018/8/2.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TQIndexChartStyle.h"
#import "TQStockChartUtilities.h"
#import "TQChartTextLayer.h"
#import "TQStockChartProtocol.h"
#import "UIBezierPath+TQChart.h"
#import "NSArray+TQChart.h"
#import "TQStockChart+Categories.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TQIndexType) {
    TQIndexTypeBEIGIN = 0,
    TQIndexTypeVOL,         // 成交量指标 volume
    TQIndexTypeBOLL,        // 布林线指标 Bollinger Bands
    TQIndexTypeMACD,        // 指数平滑移动平均线 Moving Average Convergence and Divergence
    TQIndexTypeKDJ,         // 随机指标 Stochastics
    TQIndexTypeOBV,         // 能量潮指标 On Balance Volume
    TQIndexTypeRSI,         // 相对强弱指标 Relative Strength Index
    TQIndexTypeWR,          // 威廉氏超买超卖指标 Williams Overbought/Oversold Index
    TQIndexTypeVR,          // 成交量变异率 Volume Ratio
    TQIndexTypeCR,          // 中间意愿指标、价格动量指标
    TQIndexTypeBIAS,        // 乖离率 (简称Y值也叫偏离率)
    TQIndexTypeCCI,         // 顺势指标 Commodity Channel Index
    TQIndexTypeDMI,         // 动向指标 Directional Movement Index
    TQIndexTypeDMA,         // 平行线差指标
    TQIndexTypeSAR,         // 抛物线指标 (停损点转向指标) Stop and Reverse
    TQIndexTypePSY,         // 心理线指标 (情绪指标) Psychological Line
    TQIndexTypeEND = 16
};

@interface TQIndexBaseLayer : CALayer 

/** 外观样式 */
@property (nonatomic, strong) TQIndexChartStyle *style1;

/** 绘图数据 */
@property (nonatomic, assign) CGChartPlotter plotter;

/** 数据源 */
@property (nonatomic, strong) NSArray<id<TQKlineChartProtocol>> *dataArray;

/** 更新样式 */
- (void)updateStyle;

/** 更新图表 */
- (void)updateChartWithRange:(NSRange)range;

/** 实现该方法，用于自定义当前指标范围内的最大最小值 */
- (CGPeakValue)indexChartPeakValueForRange:(NSRange)range;

/** 实现该方法，用于自定义当前指标的网格线文本内容等 */
- (NSArray<TQChartTextRenderer *> *)indexChartGraphForRange:(NSRange)range gridPath:(UIBezierPath *__autoreleasing *)pathPointer;

/** 实现该方法，用于显示当前指标计算的文本内容等 */
- (NSAttributedString *)indexChartAttributedStringForIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
