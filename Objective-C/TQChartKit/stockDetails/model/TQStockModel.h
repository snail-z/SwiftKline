//
//  TQStockModel.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/21.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStockChartProtocol.h"

@interface TQStockDetailsModel : NSObject <TQTimeChartPropProtocol>

@property (nonatomic, assign) BOOL isSuspended;
@property (nonatomic, assign) NSInteger marketId;

@property (nonatomic, assign) NSInteger stockType;
@property (nonatomic, strong) NSString *stockCode;
@property (nonatomic, strong) NSString *stockSign;
@property (nonatomic, strong) NSString *stockName;

@property (nonatomic, assign) CGFloat price_highest;
@property (nonatomic, assign) CGFloat price_lowest;
@property (nonatomic, assign) CGFloat price_open;
@property (nonatomic, assign) CGFloat price_change;
@property (nonatomic, assign) CGFloat price_changeRatio;
@property (nonatomic, assign) CGFloat price_yesterdayClose;

@property (nonatomic, assign) NSInteger date;
@property (nonatomic, assign) NSInteger dateTime;

@end

@interface TQStockTimePropModel : NSObject

@end

@interface TQStcokTimeModel : NSObject

@property (nonatomic, assign) NSInteger volume;
@property (nonatomic, assign) CGFloat price_change;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat price_change_rate;
@property (nonatomic, assign) CGFloat turnover;
@property (nonatomic, assign) NSInteger total_volume;
@property (nonatomic, assign) CGFloat avg_price;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSDate * klDate;

@end

@interface TQStockKLineModel : NSObject

@end
