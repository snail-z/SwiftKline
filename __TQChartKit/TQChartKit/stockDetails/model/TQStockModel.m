//
//  TQStockModel.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/21.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockModel.h"
#import "TQChartDateManager.h"

#pragma mark - TQStockDetailsModel

@implementation TQStockDetailsModel

@end


#pragma mark - TQStockTimePropModel

@implementation TQStockTimePropModel

@end


#pragma mark - TQStcokTimeModel

@interface TQStcokTimeModel ()

@property (nonatomic, strong) NSDate *my_date;

@end

@implementation TQStcokTimeModel

- (CGFloat)tq_timePrice {
    return self.price;
}

- (CGFloat)tq_timeAveragePrice {
    return self.avg_price;
}

- (CGFloat)tq_timeClosePrice {
    return self.price / (1 + self.price_change_rate / 100.f);
}

- (CGFloat)tq_timeVolume {
    return self.volume;
}

- (NSDate *)tq_timeDate {
    return self.my_date;
}

- (NSDate *)my_date {
    if (!_my_date) {
        _my_date = [TQChartDateManager.sharedManager dateFromString:self.date dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _my_date;
}

@end


#pragma mark - TQStockKLineModel

@interface TQStockKLineModel ()

@property (nonatomic, strong) NSDate *my_date;
@property (nonatomic, strong) NSString *my_dateText;
@property (nonatomic, assign) CGFloat my_centerX;

@end

@implementation TQStockKLineModel

- (NSDate *)my_date {
    if (!_my_date) {
        _my_date = [NSDate zh_dateFromTimestring:self.date dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _my_date;
}

- (CGFloat)tq_open {
    return self.open_price;
}

- (CGFloat)tq_close {
    return self.close_price;
}

- (CGFloat)tq_high {
    return self.high_price;
}

- (CGFloat)tq_low {
    return self.low_price;
}

- (NSDate *)tq_date {
    return self.my_date;
}

- (CGFloat)tq_closeYesterday {
    return self.tq_close;
}

- (CGFloat)tq_volume {
    return self.volume / 1000000.f;
}

@end
