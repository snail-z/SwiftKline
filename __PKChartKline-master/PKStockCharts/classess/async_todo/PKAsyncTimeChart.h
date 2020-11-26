//
//  PKAsyncTimeChart.h
//  PKStockCharts
//
//  Created by zhanghao on 2019/7/31.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKTimeChartProtocol.h"
#import "PKTimeChartSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface PKAsyncTimeChart : UIView

@property (nonatomic, weak, nullable) NSObject<PKTimeChartCoordProtocol> *coordinates;

/** 设置图表样式 */
@property (nonatomic, strong) PKTimeChartSet *set;

/** 数据源走势列表 */
@property (nonatomic, strong) NSArray<id<PKTimeChartProtocol>> *dataList;

/** 绘制图表 */
- (void)drawChart;

@end

NS_ASSUME_NONNULL_END
