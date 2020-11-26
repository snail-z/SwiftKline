//
//  PKLandscapeViewController+Extend.h
//  PKStockCharts
//
//  Created by zhanghao on 2019/8/22.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "PKLandscapeViewController.h"
#import "PKTimeChart.h"
#import "PKKLineChart.h"
#import "PKStockObjects.h"

NS_ASSUME_NONNULL_BEGIN

@interface PKLandscapeViewController (Extend)

/** 分时图样式 */
- (PKTimeChartSet *)makeOneTimeChartSet;

/** 五日分时图样式 */
- (PKTimeChartSet *)makeFiveTimeChartSet;

/** K线图样式设置 */
- (PKKLineChartSet *)makeKlineChartSet;

@end

NS_ASSUME_NONNULL_END
