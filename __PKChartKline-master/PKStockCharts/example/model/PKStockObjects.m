
//
//  PKStockObjects.m
//  PKStockCharts
//
//  Created by zhanghao on 2019/7/12.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "PKStockObjects.h"
#import <PKCategories/PKCategories.h>

@implementation PKStockItem

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"times" : [PKTimeItem class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"name" : @"stock_name",
             @"code" : @"stock_code"};
}

@end

@implementation PKTimeItem

- (CGFloat)pk_averagePrice {
    return self.lead_price;
}

- (nonnull NSDate *)pk_dateTime {
    NSDate *date = [NSDate pk_dateFromString:self.date formatter:@"HH:mm"];
    return date;
}

- (CGFloat)pk_latestPrice {
    return self.price;
}

- (CGFloat)pk_volume {
    return (CGFloat)(self.volume);
}

- (CGFloat)pk_leadRGBarVolume {
    return self.lead_volume;
}

- (BOOL)pk_isLeadRGBarUpward {
    return self.lead_upward;
}

- (CGFloat)pk_referenceValue {
    return self.pre_close_price;
}

@end


@interface PKKlineItem ()

@property (nonatomic, strong) NSDate *my_date;

@end

@implementation PKKlineItem

/** 开盘价 */
- (CGFloat)pk_kOpenPrice {
    return self.open_price;
}

/** 最高价 */
- (CGFloat)pk_kHighPrice {
    return self.high_price;
}

/** 最低价 */
- (CGFloat)pk_kLowPrice {
    return self.low_price;
}

/** 收盘价 */
- (CGFloat)pk_kClosePrice {
    return self.close_price;
}

/** 成交量 */
- (CGFloat)pk_kVolume {
    return self.volume;
}

/** 日期时间 */
- (NSDate *)pk_kDateTime {
    return self.my_date;
}

- (NSDate *)my_date {
    if (!_my_date) {
        _my_date = [NSDate pk_dateFromString:self.date formatter:@"yyyy-MM-dd"];
    }
    return _my_date;
}

@end
