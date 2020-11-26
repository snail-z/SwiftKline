//
//  PKKLineChart+Frame.h
//  PKStockCharts
//
//  Created by zhanghao on 2019/7/20.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "PKKLineChart+Frame.h"

NS_ASSUME_NONNULL_BEGIN

/** 更新图表后会计算出以下frame */
@interface PKKLineChart ()

/** 内容区域 */
@property (nonatomic, assign, readonly) CGRect contentChartFrame;

/** 中间分隔区域 */
@property (nonatomic, assign, readonly) CGRect separatedFrame;

/** 主图区域 */
@property (nonatomic, assign, readonly) CGRect majorChartFrame;

/** 副图区域 */
@property (nonatomic, assign, readonly) CGRect minorChartFrame;

@end

NS_ASSUME_NONNULL_END
