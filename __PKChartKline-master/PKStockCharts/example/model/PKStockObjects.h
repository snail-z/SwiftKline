//
//  PKStockObjects.h
//  PKStockCharts
//
//  Created by zhanghao on 2019/7/12.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKTimeChartProtocol.h"
#import "PKKLineChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class PKTimeItem;
@interface PKStockItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *market;
@property (nonatomic, assign) CGFloat high_price;
@property (nonatomic, assign) CGFloat low_price;
@property (nonatomic, strong) NSArray<PKTimeItem *> *times;

@end

@interface PKTimeItem : NSObject <PKTimeChartProtocol, PKTimeChartCoordProtocol>

@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat avg_price;
@property (nonatomic, assign) CGFloat pre_close_price;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) NSInteger volume;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, assign) CGFloat lead_price;
@property (nonatomic, assign) CGFloat lead_volume;
@property (nonatomic, assign) BOOL lead_upward;

@end

@interface PKKlineItem : NSObject <PKKLineChartProtocol>

@property (nonatomic, assign) CGFloat open_price; // 开盘价
@property (nonatomic, assign) CGFloat close_price; // 收盘价
@property (nonatomic, assign) CGFloat high_price; // 最高价
@property (nonatomic, assign) CGFloat low_price; // 最低价
@property (nonatomic, assign) CGFloat pre_close_price; // 昨收
@property (nonatomic, assign) CGFloat price_change; // 涨跌额
@property (nonatomic, assign) CGFloat price_change_rate; // 涨跌幅
@property (nonatomic, assign) CGFloat amount; // 成交额
@property (nonatomic, assign) CGFloat volume; // 成交量
@property (nonatomic, copy) NSString *date; // 日期
//@property (nonatomic, assign) CGFloat turnover_ratio; // 换手率
//@property (nonatomic, assign) CGFloat total_position; //持仓量

@end

NS_ASSUME_NONNULL_END
