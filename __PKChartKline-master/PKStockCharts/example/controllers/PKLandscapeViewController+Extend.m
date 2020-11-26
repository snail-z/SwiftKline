//
//  PKLandscapeViewController+Extend.m
//  PKStockCharts
//
//  Created by zhanghao on 2019/8/22.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "PKLandscapeViewController+Extend.h"

@implementation PKLandscapeViewController (Extend)

- (PKTimeChartSet *)makeOneTimeChartSet {
    PKTimeChartSet *set = [PKTimeChartSet defaultSet];
    set.chartType = PKTimeChartTypeOneDay;
    set.crossLineConstrained = NO;
    set.maxDataCount = 242;
    set.datePosition = PKChartDatePositionMiddle;
    set.timelineDisplayTexts = @[@"09:30", @"11:30/13:00", @"15:00"];
    return set;
}

- (PKTimeChartSet *)makeFiveTimeChartSet {
    PKTimeChartSet *set = [PKTimeChartSet defaultSet];
    set.chartType = PKTimeChartTypeFiveDays;
    set.maxDataCount = 241 * 5;
    set.shapeGap = 0.05;
    set.dateFormatter = PKChartDateFormat_Md;
    set.crossDateFormatter = PKChartDateFormat_MdHm;
    set.showFlashing = YES;
    return set;
}

- (PKKLineChartSet *)makeKlineChartSet {
    PKKLineChartSet *set = [PKKLineChartSet defaultSet];
    set.datePosition = PKChartDatePositionMiddle;
    set.numberOfVisible = 90;
    return set;
}

@end
